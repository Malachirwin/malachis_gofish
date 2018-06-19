require_relative "app.rb"
require "capybara/rspec"
require "sinatra"
require "rack/test"
require "pry"
Capybara.app = App.new

describe 'app', {:type => :feature} do
  it('sees if when you join it goes to the next page.') do
    visit('/')
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

  it("does multiple sessions") do
    session1 = Capybara::Session.new(:rack_test, App.new)
    session2 = Capybara::Session.new(:rack_test, App.new)
    session3 = Capybara::Session.new(:rack_test, App.new)
    [session1, session2].each do |session|
      session.visit("/")
      session.click_on("join")
      expect(session).to have_content("Waiting for opponents")
    end
    session3.visit("/")
    session3.click_on("join")
    expect(session3).to have_content("your hand")
    session1.visit("/game")
    session2.visit("/game")
    session3.visit("/game")
    expect(session1).to have_content("your hand")
    expect(session2).to have_content("your hand")
    expect(session3).to have_content("your hand")
  end
end
