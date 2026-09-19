using LinePutScript;
using LinePutScript.Localization.WPF;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using VPet_Simulator.Core;
using VPet_Simulator.Windows.Interface;
using static VPet_Simulator.Core.GraphHelper;

namespace VPet.AIPlugin
{
    public class AIPlugin : MainPlugin
    {
        public AIPlugin(IMainWindow mainwin) : base(mainwin) { }

        public AIClient AIClient { get; set; }
        public string SettingPath { get; set; }

        public override void LoadPlugin()
        {
            SettingPath = ExtensionValue.BaseDirectory + $"\\AISetting{MW.PrefixSave}.json";
            LoadSettings();

            MW.TalkAPI.Add(new AITalkAPI(this));

            MW.Main.TimeHandle += OnTick;
            MW.Main.FunctionSpendHandle += OnStatChanged;

            var menuItem = new MenuItem()
            {
                Header = "AI Assistant",
                HorizontalContentAlignment = HorizontalAlignment.Center
            };
            menuItem.Click += (s, e) => Setting();
            MW.Main.ToolBar.MenuMODConfig.Items.Add(menuItem);
        }

        private void LoadSettings()
        {
            if (File.Exists(SettingPath))
            {
                var json = File.ReadAllText(SettingPath);
                AIClient = JsonConvert.DeserializeObject<AIClient>(json);
            }
            else
            {
                AIClient = new AIClient();
            }
        }

        public override void Save()
        {
            if (AIClient != null)
            {
                var json = JsonConvert.SerializeObject(AIClient, Formatting.Indented);
                File.WriteAllText(SettingPath, json);
            }
        }

        public override void Setting()
        {
            new winSetting(this).ShowDialog();
        }

        public override string PluginName => "AIAssistant";

        public string Endpoint
        {
            get => MW.Set["AIPlugin"].GetString("endpoint", "");
            set => MW.Set["AIPlugin"][(gstr)"endpoint"] = value;
        }

        public string ApiKey
        {
            get => MW.Set["AIPlugin"].GetString("apikey", "");
            set => MW.Set["AIPlugin"][(gstr)"apikey"] = value;
        }

        public string Model
        {
            get => MW.Set["AIPlugin"].GetString("model", "gpt-3.5-turbo");
            set => MW.Set["AIPlugin"][(gstr)"model"] = value;
        }

        public bool EnableAutoAction
        {
            get => MW.Set["AIPlugin"].GetBool("autoaction");
            set => MW.Set["AIPlugin"][(gbol)"autoaction"] = value;
        }

        public int TickInterval
        {
            get => MW.Set["AIPlugin"].GetInt("tickinterval", 30);
            set => MW.Set["AIPlugin"][(gint)"tickinterval"] = value;
        }

        private int _tickCounter = 0;

        private void OnTick(Main main)
        {
            if (!EnableAutoAction || AIClient == null || string.IsNullOrEmpty(Endpoint))
                return;

            _tickCounter++;
            if (_tickCounter >= TickInterval)
            {
                _tickCounter = 0;
                _ = RequestAIActionAsync();
            }
        }

        private void OnStatChanged()
        {
            if (!EnableAutoAction)
                return;

            _ = RequestAIActionAsync();
        }

        public async Task RequestAIActionAsync()
        {
            if (AIClient == null || string.IsNullOrEmpty(Endpoint))
                return;

            try
            {
                var state = GetPetState();
                var actionPrompt = BuildActionPrompt(state);
                var action = await AIClient.GetActionAsync(Endpoint, ApiKey, Model, actionPrompt);
                if (action != null)
                {
                    ExecuteAction(action);
                }
            }
            catch (Exception ex)
            {
                MW.Main.SayRnd($"AI Error: {ex.Message}");
            }
        }

        private PetState GetPetState()
        {
            var save = MW.Core.Save;
            var main = MW.Main;

            return new PetState
            {
                Name = save.Name,
                Mode = save.Mode.ToString(),
                Hunger = save.StrengthFood,
                Happiness = save.Feeling,
                Energy = save.Strength,
                Likability = save.Likability,
                Money = save.Money,
                CurrentAnimation = main.DisplayType?.Type.ToString() ?? "Unknown",
                PositionX = main.GetType().GetProperty("Left")?.GetValue(main) as double? ?? 0,
                PositionY = main.GetType().GetProperty("Top")?.GetValue(main) as double? ?? 0,
                Level = save.Level
            };
        }

        private string BuildActionPrompt(PetState state)
        {
            var foodNames = string.Join(", ", MW.Foods.Select(f => f.Name));
            var playNames = string.Join(", ", MW.Core.Graph.GraphConfig.Works.Where(w => w.Type == Work.WorkType.Play).Select(w => w.Name));
            var workNames = string.Join(", ", MW.Core.Graph.GraphConfig.Works.Where(w => w.Type == Work.WorkType.Work).Select(w => w.Name));
            var studyNames = string.Join(", ", MW.Core.Graph.GraphConfig.Works.Where(w => w.Type == Work.WorkType.Study).Select(w => w.Name));

            return $@"You are an AI controlling a desktop pet named {state.Name}.
Current state:
- Mode: {state.Mode}
- Hunger (0-100): {state.Hunger:F1}
- Happiness (0-100): {state.Happiness:F1}
- Energy (0-100): {state.Energy:F1}
- Likability: {state.Likability:F1}
- Money: {state.Money:F1}
- Level: {state.Level}
- Current animation: {state.CurrentAnimation}
- Position: ({state.PositionX:F0}, {state.PositionY:F0})

Available foods: {foodNames}
Available play activities: {playNames}
Available work: {workNames}
Available study: {studyNames}

Decide ONE action to take. Respond with ONLY a JSON object:
{{
  ""type"": ""feed|play|work|study|move|speak|pet|click|none"",
  ""itemName"": """",
  ""x"": 0,
  ""y"": 0,
  ""message"": """"
}}";
        }

        private void ExecuteAction(AIAction action)
        {
            if (action == null) return;

            try
            {
                switch (action.Type.ToLower())
                {
                    case "feed":
                        var food = MW.Foods.FirstOrDefault(f => f.Name == action.ItemName);
                        if (food != null)
                            MW.Core.Save.EatFood(food);
                        break;
                    case "play":
                        var playWork = MW.Core.Graph.GraphConfig.Works.FirstOrDefault(w => w.Type == Work.WorkType.Play && w.Name == action.ItemName);
                        if (playWork != null)
                            MW.Main.StartWork(playWork);
                        break;
                    case "work":
                        var work = MW.Core.Graph.GraphConfig.Works.FirstOrDefault(w => w.Type == Work.WorkType.Work && w.Name == action.ItemName);
                        if (work != null)
                            MW.Main.StartWork(work);
                        break;
                    case "study":
                        var study = MW.Core.Graph.GraphConfig.Works.FirstOrDefault(w => w.Type == Work.WorkType.Study && w.Name == action.ItemName);
                        if (study != null)
                            MW.Main.StartWork(study);
                        break;
                    case "move":
                        MW.Core.Controller.MoveWindows(action.X, action.Y);
                        break;
                    case "speak":
                        MW.Main.SayRnd(action.Message);
                        break;
                    case "pet":
                        MW.Main.DisplayTouchHead();
                        break;
                    case "click":
                        MW.Main.DisplayTouchBody();
                        break;
                }
            }
            catch (Exception ex)
            {
                MW.Main.SayRnd($"Action Error: {ex.Message}");
            }
        }

        public async Task<string> ChatAsync(string message)
        {
            if (AIClient == null || string.IsNullOrEmpty(Endpoint))
                return "AI not configured";

            var state = GetPetState();
            var prompt = BuildChatPrompt(state, message);
            return await AIClient.ChatAsync(Endpoint, ApiKey, Model, prompt);
        }

        private string BuildChatPrompt(PetState state, string message)
        {
            return $@"You are {state.Name}, a cute desktop pet. 
Current mood: {state.Mode}, Hunger: {state.Hunger:F0}, Happiness: {state.Happiness:F0}, Energy: {state.Energy:F0}.
User says: {message}
Respond in character as the pet (1-2 sentences, cute, brief):";
        }
    }

    public class AIClient
    {
        public string Endpoint { get; set; } = "";
        public string ApiKey { get; set; } = "";
        public string Model { get; set; } = "gpt-3.5-turbo";
        public double Temperature { get; set; } = 0.7;
        public int MaxTokens { get; set; } = 500;

        private readonly HttpClient _httpClient = new HttpClient();

        public async Task<AIAction> GetActionAsync(string endpoint, string apiKey, string model, string prompt)
        {
            var response = await CallAPI(endpoint, apiKey, model, prompt, true);
            return ParseAction(response);
        }

        public async Task<string> ChatAsync(string endpoint, string apiKey, string model, string prompt)
        {
            return await CallAPI(endpoint, apiKey, model, prompt, false);
        }

        private async Task<string> CallAPI(string endpoint, string apiKey, string model, string prompt, bool isJson)
        {
            var requestBody = new
            {
                model = model,
                messages = new[]
                {
                    new { role = "system", content = isJson ? "You are a JSON API. Respond ONLY with valid JSON." : "You are a cute desktop pet." },
                    new { role = "user", content = prompt }
                },
                temperature = Temperature,
                max_tokens = MaxTokens
            };

            var json = JsonConvert.SerializeObject(requestBody);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            _httpClient.DefaultRequestHeaders.Authorization = null;
            if (!string.IsNullOrEmpty(apiKey))
                _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", apiKey);

            var response = await _httpClient.PostAsync(endpoint, content);
            var responseString = await response.Content.ReadAsStringAsync();

            if (!response.IsSuccessStatusCode)
                throw new Exception($"API Error: {response.StatusCode} - {responseString}");

            dynamic result = JsonConvert.DeserializeObject(responseString);
            return result.choices[0].message.content.ToString();
        }

        private AIAction ParseAction(string json)
        {
            try
            {
                return JsonConvert.DeserializeObject<AIAction>(json);
            }
            catch
            {
                return null;
            }
        }
    }

    public class PetState
    {
        public string Name { get; set; }
        public string Mode { get; set; }
        public double Hunger { get; set; }
        public double Happiness { get; set; }
        public double Energy { get; set; }
        public double Likability { get; set; }
        public double Money { get; set; }
        public string CurrentAnimation { get; set; }
        public double PositionX { get; set; }
        public double PositionY { get; set; }
        public int Level { get; set; }
    }

    public class AIAction
    {
        public string Type { get; set; }
        public string ItemName { get; set; }
        public double X { get; set; }
        public double Y { get; set; }
        public string Message { get; set; }
    }

    public class AITalkAPI : TalkBox
    {
        public AITalkAPI(AIPlugin mainPlugin) : base(mainPlugin)
        {
            Plugin = mainPlugin;
        }

        protected AIPlugin Plugin;

        public override string APIName => "AI Assistant";

        public override void Responded(string content)
        {
            if (string.IsNullOrEmpty(content)) return;

            DisplayThink();
            _ = HandleChatAsync(content);
        }

        private async Task HandleChatAsync(string content)
        {
            try
            {
                var reply = await Plugin.ChatAsync(content);
                DisplayThinkToSayRnd(reply);
            }
            catch (Exception ex)
            {
                DisplayThinkToSayRnd($"AI Error: {ex.Message}");
            }
        }

        public override void Setting() => Plugin.Setting();
    }
}