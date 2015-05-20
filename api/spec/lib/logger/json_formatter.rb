module Sentinel
  describe JsonFormatter do
    let(:formatter) { described_class.new }
    let(:json) do
      {
        :path=>'/',
        :params=>{},
        :method=>'GET',
        :total=>9.33,
        :db=>0.0,
        :status=>200,
        :datatime=>'2015-05-19 18:04:08 +0200',
        :severity=>"INFO"
      }
    end

    let(:exception) do
      Exception.new('"\xF0" from ASCII-8BIT to UTF-8')
    end

    let(:string) { "This is a logs"}

    describe "#format" do

      it "returns a json" do
        expect(formatter.format(json)).to be_a(Hash)
        expect(formatter.format(expection)).to be_a(Hash)
        expect(formatter.format(string)).to be_a(Hash)
      end
    end
  end
end
