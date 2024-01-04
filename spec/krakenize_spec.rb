require 'database'

describe Krakenize do
  include TestHelper

  shared_examples_for 'a valid association' do
    it { should be_present }
    it 'has valid "name," "macro," and "klass" options' do
      subject.name.should be_a(Symbol)
      subject.macro.should be_a(Symbol)
      subject.klass.should be_a(Class)
    end
  end

  # non-Kraken models.

  describe 'a non-Kraken model' do
    subject { create_class('NonKrakenModel') }
    it { should respond_to(:kraken_model?, :to_kraken, :krakenize_association) }
    it { should_not be_a_kraken_model }

    it 'raises ConfigurationError if krakenize_association is called' do
      expect {
        NonKrakenModel.krakenize_association :anything
      }.to raise_error(Krakenize::ConfigurationError)
    end
  end

  describe 'a non-Kraken model without a Kraken equivalent' do
    subject { create_class('ClassWithoutKrakenEquivalent') }
    its(:to_kraken) { should == subject }
  end

  describe 'a non-Kraken model with a Kraken equivalent' do
    subject do
      create_class('ClassWithKrakenEquivalent')
      create_kraken_class(ClassWithKrakenEquivalent)
      ClassWithKrakenEquivalent
    end

    its(:to_kraken) { should == Kraken::ClassWithKrakenEquivalent }
  end

  # Kraken models.

  describe 'a Kraken model' do
    before do
      create_class('Hatchery')
      create_kraken_class(Hatchery)
    end

    subject { Kraken::Hatchery }
    it { should respond_to(:kraken_model?, :to_kraken, :krakenize_association) }
    it { should be_a_kraken_model }
    its(:to_kraken) { should == subject }

    it 'can call krakenize_association on existing associations' do
      create_class('Hydralisk')
      Hatchery.has_many :hydralisks
      expect {
        Kraken::Hatchery.krakenize_association :hydralisks
      }.to_not raise_error
    end
  end

  describe 'a Kraken model with inherited associations' do
    before do
      create_classes('Lurker', 'Spike')
      Lurker.has_many :spikes
      create_kraken_class(Lurker)
    end

    subject { Kraken::Lurker.reflect_on_association(:spikes) }
    it_behaves_like 'a valid association'
  end

  describe 'krakenized associations with classes that have kraken equivalents' do
    before do
      create_classes('Queen', 'Broodling')
      Queen.has_many :broodlings, :dependent => :destroy, :autosave => true

      create_kraken_classes(Queen, Broodling)
      Kraken::Queen.krakenize_association :broodlings, :autosave => false
    end

    subject { Kraken::Queen.reflect_on_association(:broodlings) }

    it 'adds a class_name attribute' do
      subject.send(:options).should include(:class_name => 'Kraken::Broodling')
    end

    it 'retains options from the original association' do
      subject.send(:options).should include(:dependent => :destroy)
    end

    it 'can override options on the original association' do
      subject.send(:options).should include(:autosave => false)
    end
  end

  describe 'krakenized associations with :class_name options specified' do
    before do
      create_classes('Ultralisk', 'Flea', 'SpecialFlea')
      Ultralisk.has_many :fleas, :class_name => 'SpecialFlea'

      create_kraken_classes(Ultralisk, Flea, SpecialFlea)
      Kraken::Ultralisk.krakenize_association :fleas
    end

    subject { Kraken::Ultralisk.reflect_on_association(:fleas) }

    it 'retains the original :class_name' do
      subject.send(:options).should include(:class_name => 'SpecialFlea')
    end
  end
end
