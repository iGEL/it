module It
  class Plain < Tag
    def initialize(template = "%s")
      raise TypeError, "expected a String, got #{template.class}" unless template.is_a?(String)
      @template = template
    end

    def process(content = '')
      sprintf(@template, content)
    end
  end
end
