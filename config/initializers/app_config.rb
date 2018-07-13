APP_CONFIG = YAML.load(ERB.new(IO.read("#{Rails.root}/config/config.yml")).result)[Rails.env]
