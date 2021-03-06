namespace :doc do
  namespace :diagrams do
    desc "Draw model diagrams"
    task :models do
      doc_diagrams_generate('models', '-a -m -M', 'neato')
    end

    desc "Draw controller diagrams"
    task :controllers do
      doc_diagrams_generate('controllers', '-C', 'neato')
    end

    desc "Draw states diagrams"
    task :states do
      doc_diagrams_generate('states', '-A', 'dot')
    end
  end

  desc "Draw controllers, models & states diagrams"
  task :diagrams => %w(diagrams:models diagrams:controllers diagrams:states)
end


def doc_diagrams_generate(type, options, dot_cmd)
  railroad = "railroad" # or "./vendor/plugins/railroad/bin/railroad"
  options = "-v -j -l -i #{options}"
  output_dir = "doc/diagrams"

  FileUtils.mkdir(output_dir) unless File.exist?(output_dir)

  sh "#{railroad} -o #{output_dir}/#{type}.dot #{options}"
  sh "#{dot_cmd} -Tpng #{output_dir}/#{type}.dot -o #{output_dir}/#{type}.png"
  sh "#{dot_cmd} -Tsvg #{output_dir}/#{type}.dot | sed 's/font-size:14.00/font-size:11px/g' > #{output_dir}/#{type}.svg"
end

