class SpecUtilities
  class << self
    def to_csv(array)
      array.map {|v| v.to_s}.join(',')
    end
  end
end