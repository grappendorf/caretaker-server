class Class
  def register *args, &block
    ::MICON.register(*args, &block)
  end
end

def register *args, &block
  ::MICON.register(*args, &block)
end

def lookup name
  ::MICON[name]
end

def registered? name
  ::MICON.include? name
end