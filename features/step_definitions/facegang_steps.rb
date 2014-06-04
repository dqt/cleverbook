Then(/^there should be a description of what the app does$/) do
  output_lines = all_output.split(/\n/)
  #output_lines.should have_at_least(3).items
  expect(output_lines.size).to be >= 3
  # [0] is our banner, which we've checked for
  expect(output_lines[1]).to match(/^\s*$/)
  expect(output_lines[2]).to match(/^\w+\s+\w+/)
end

Given(/^a configuration file exists at "(.*?)"$/) do |arg1|
  expect(File).to exist(arg1)
end

Then(/^the configuration file "(.*?)" should be loaded into a config Hash$/) do |arg1|
  hash = YAML::load(File.read(arg1))
  expect(hash.class).to eq(Hash)
end

Then(/^the config Hash should contain app_id$/) do
  expect(hash["app_id").to_not be_blank
end

Then(/^the config Hash should contain app_secret$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the config Hash should contain site_url$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the config Hash should contain my_id$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the config Hash should contain email$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the config Hash should contain password$/) do
  pending # express the regexp above with the code you wish you had
end
