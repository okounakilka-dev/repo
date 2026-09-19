using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using VPet_Simulator.Windows.Interface;

namespace VPet.AIPlugin
{
    public partial class winSetting : Window
    {
        private readonly AIPlugin _plugin;

        public winSetting(AIPlugin plugin)
        {
            InitializeComponent();
            _plugin = plugin;

            if (_plugin.AIClient != null)
            {
                tbEndpoint.Text = _plugin.AIClient.Endpoint;
                tbApiKey.Password = _plugin.AIClient.ApiKey;
                cbModel.Text = _plugin.AIClient.Model;
                slTemperature.Value = _plugin.AIClient.Temperature;
                tbMaxTokens.Text = _plugin.AIClient.MaxTokens.ToString();
            }

            cbAutoAction.IsChecked = _plugin.EnableAutoAction;
            tbTickInterval.Text = _plugin.TickInterval.ToString();
        }

        private async void BtnTest_Click(object sender, RoutedEventArgs e)
        {
            btnTest.IsEnabled = false;
            btnTest.Content = "Testing...";

            try
            {
                var client = new HttpClient();
                var requestBody = new
                {
                    model = cbModel.Text,
                    messages = new[]
                    {
                        new { role = "user", content = "Hello" }
                    },
                    max_tokens = 10
                };

                var json = JsonConvert.SerializeObject(requestBody);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                if (!string.IsNullOrEmpty(tbApiKey.Password))
                    client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", tbApiKey.Password);

                var response = await client.PostAsync(tbEndpoint.Text, content);
                var result = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    MessageBox.Show("Connection successful!", "Test Result", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                {
                    MessageBox.Show($"Error: {response.StatusCode}\n{result}", "Test Failed", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Connection failed: {ex.Message}", "Test Failed", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            finally
            {
                btnTest.IsEnabled = true;
                btnTest.Content = "Test Connection";
            }
        }

        private void BtnSave_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(tbEndpoint.Text))
            {
                MessageBox.Show("Please enter an API endpoint", "Error", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            _plugin.AIClient = new AIClient
            {
                Endpoint = tbEndpoint.Text.Trim(),
                ApiKey = tbApiKey.Password,
                Model = cbModel.Text.Trim(),
                Temperature = slTemperature.Value,
                MaxTokens = int.TryParse(tbMaxTokens.Text, out var mt) ? mt : 500
            };

            _plugin.EnableAutoAction = cbAutoAction.IsChecked == true;
            _plugin.TickInterval = int.TryParse(tbTickInterval.Text, out var ti) ? ti : 30;

            _plugin.Save();
            this.Close();
        }

        private void BtnCancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}