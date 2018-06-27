require "rack/test"
require "rspec"
require "capybara"
require "capybara/rspec"
require "selenium/webdriver"
require "pry"

ENV["RACK_ENV"] = 'test'

require_relative "react"

Capybara.configure do |config|
  config.run_server = false
  config.app_host = "http://localhost:3000"
  config.default_driver = :selenium_chrome_headless
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

RSpec.describe App, type: :feature do
  describe "POST /join", :js do
    it "can submit a name" do
      visit "/"
      expect(page).to have_content "Please enter your name"
      fill_in "name", with: "Malachi"
      click_button "Submit"
      expect(page).to have_content "Go fish"
    end
  end
end
