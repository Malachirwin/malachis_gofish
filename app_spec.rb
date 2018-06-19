require_relative "app.rb"
require "capybara/rspec"
require "sinatra"
Capybara.app = App.new

describe 'app', {:type => :feature} do
  it('sees if when you join it goes to the next page.') do
    visit('/')
    fill_in(:number_of_players, :with => '5')
    click_button('join')
    expect(page).to have_content('Waiting for opponents')
  end

  it('sees if when you join it goes to the next page.') do
    visit('/')
    expect(page).to have_content('Welcome to Go Fish')
  end

  it("loads the static game page") do
    visit('/game')
    expect(page).to have_content('your hand')
  end
end
