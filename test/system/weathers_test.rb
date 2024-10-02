require "application_system_test_case"

class WeathersTest < ApplicationSystemTestCase
  setup do
    @weather = weathers(:one)
  end

  test "visiting the index" do
    visit weathers_url
    assert_selector "h1", text: "Weathers"
  end

  test "should create weather" do
    visit weathers_url
    click_on "New weather"

    fill_in "Humidity", with: @weather.humidity
    fill_in "Temp", with: @weather.temp
    fill_in "Temp high", with: @weather.temp_high
    fill_in "Temp low", with: @weather.temp_low
    fill_in "Time", with: @weather.time
    fill_in "Weather owm icon code", with: @weather.weather_OWM_icon_code
    fill_in "Weather desc", with: @weather.weather_desc
    fill_in "Wind", with: @weather.wind
    click_on "Create Weather"

    assert_text "Weather was successfully created"
    click_on "Back"
  end

  test "should update Weather" do
    visit weather_url(@weather)
    click_on "Edit this weather", match: :first

    fill_in "Humidity", with: @weather.humidity
    fill_in "Temp", with: @weather.temp
    fill_in "Temp high", with: @weather.temp_high
    fill_in "Temp low", with: @weather.temp_low
    fill_in "Time", with: @weather.time.to_s
    fill_in "Weather owm icon code", with: @weather.weather_OWM_icon_code
    fill_in "Weather desc", with: @weather.weather_desc
    fill_in "Wind", with: @weather.wind
    click_on "Update Weather"

    assert_text "Weather was successfully updated"
    click_on "Back"
  end

  test "should destroy Weather" do
    visit weather_url(@weather)
    click_on "Destroy this weather", match: :first

    assert_text "Weather was successfully destroyed"
  end
end
