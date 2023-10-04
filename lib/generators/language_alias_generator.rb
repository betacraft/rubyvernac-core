class LanguageAliasGenerator

  def alias_class_method(class_name, orig_name, alias_name)
    klass = Object.class_eval(class_name)
    singleton_klass = klass.singleton_class

    singleton_klass.send(:alias_method, alias_name.to_sym, orig_name.to_sym)
  rescue StandardError => e
    puts e.message
  end

  def alias_instance_method(class_name, orig_name, alias_name)
    klass = Object.class_eval(class_name)

    klass.send(:alias_method, alias_name.to_sym, orig_name.to_sym)
  rescue StandardError => e
    puts e.message
  end

end