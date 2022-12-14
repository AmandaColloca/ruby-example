require_relative "./hooks_config/main_hooks_config"

Before do

  # Set remote default server
  Capybara.app_host = DATA['carbono']

  # Set short-hand List
  @front_auth   ||= FrontAuthenticationPage.new
  @register_b2c ||= RegisterUserB2CPage.new
  @register_b2b ||= RegisterUserB2BPage.new  
  @braspag      ||= Braspag.new
  @products     ||= Products.new 
  @shipping     ||= Shipping.new
  @adyen        ||= Adyen.new 
  
  # Cleaning out the pool of sessions. This will remove any session information such as cookies.
  page.reset_session!
  # Configure Window Size
  HooksConfig.get_window_webdriver_config(page.driver) unless Capybara.default_driver === :chrome_cuprite
end
  
After do |scn|
  binding.pry if scn.failed? && ENV['debug']
  
  # Set screenshot configuration
  if ENV['screenshot']
    screenshot = HooksConfig.take_screenshot(scn)
    attach(screenshot, 'image/png')
  end
      
  # Set reset session hook
  page.execute_script('sessionStorage.clear()') 
  Capybara.current_session.driver.quit
  # @session.driver.quit unless @session.nil?
end