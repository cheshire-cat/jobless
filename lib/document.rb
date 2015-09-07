require 'erb'

module Jobless
  class Document
    attr_reader :groups

    def initialize
      @data = {}
      @groups = []
    end

    # Define methods for setting personal data
    %w(name location homepage email).each do |attribute_name|
      define_method(attribute_name) do |attribute=nil|
        if attribute
          @data[attribute_name.to_sym] = attribute
        else
          @data[attribute_name.to_sym]
        end
      end
    end

    def group(name, type=nil, &block)
      group = Group.new(name, type)
      group.instance_eval &block
      @groups.push group
    end

    def employment(&block)
      group("Employment", :employment, &block)
    end

    def education(&block)
      group("Education", :education, &block)
    end

    def open_source(&block)
      group("Open source contributions", :open_source, &block)
    end

    def other_experience(&block)
      group("Other experience", :other_experience, &block)
    end

    def write_to_file(filename)
      template_path = File.expand_path("../template.html.erb", __FILE__)
      renderer = ERB.new(File.read(template_path))
      generated_html = renderer.result(binding)
      File.open(filename, 'w') do |file|
        file.write(generated_html)
      end
    end
  end
end