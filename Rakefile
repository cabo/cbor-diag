task default: "lib/cbor-diag-parser.rb"

desc 'Generate treetop parser'
file "lib/cbor-diag-parser.rb" => ["lib/cbor-diag-parser.treetop"] do |t|
  sh "tt #{t.source}"
end

desc 'Build the gem'
task :build => "lib/cbor-diag-parser.rb" do
  sh "gem build cbor-diag.gemspec"
end
