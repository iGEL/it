module It
  # Handles replacements in non HTML templates (e.g. mails)
  class Plain < Tag
    def initialize(template = '%s')
      fail TypeError, "expected a String, got #{template.class}" unless template.is_a?(String)

      @template = template
    end

    def process(content = '')
      format(@template, content)
    end
  end
end
