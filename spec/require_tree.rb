def require_folder(dir)
  Dir[File.join(Dir.pwd, dir, '**/*.rb')].each do |file|
    require file
  end
end
