module V1
  module Routes
    class Exercises < Sinatra::Application
      IGNORE = [
        Regexp.new("\/\.$"),
      ]

      helpers ::V1::Helpers::Guards

      before do
        content_type 'application/json', charset: 'utf-8'
      end

      before do 
        require_key
      end

      get "/exercises" do
        File.open(ROOT + "/exercises/exercises.json").read 
      end

      get "/exercises/:name" do 
        begin
          tempfile = Tempfile.new("foo")
          create_zip(tempfile)

          send_file tempfile.path, 
            type: 'application/zip', 
            disposition: 'attachment', 
            filename: "#{params[:name]}.zip"
        ensure
          tempfile.close
          tempfile.unlink
        end
      end

      private

        def create_zip(tempfile)
          Zip::OutputStream.open(tempfile.path) do |io|
            paths.each do |path|
              p path
              io.put_next_entry(filename(path))
              io.print IO.read(path)
            end
          end
        end

        # Include dotfiles File::FNM_DOTMATCH
        def paths 
          Dir.glob("#{dir}/**/*", File::FNM_DOTMATCH).reject do |f|
            File.directory?(f) || IGNORE.any? { |pattern| f =~ pattern }
          end
        end

        def dir 
          "#{ROOT}/exercises/#{params[:name]}"
        end

        def filename(f)
          f.gsub(dir, "").sub!(%r{^\/},"")
        end
    end
  end
end