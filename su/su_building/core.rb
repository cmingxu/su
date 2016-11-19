class String
  def camelize
    self.split('_').map {|w| w.capitalize}.join
  end
end

class Hash
  def to_query
    map do |k, v|
      "#{k}=#{v}"
    end.join "&"
  end
end
