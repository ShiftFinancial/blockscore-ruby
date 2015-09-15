module BlockScore
  RSpec.describe Person do
    describe '.new' do
      subject(:person) do
        BlockScore::Person.new(
          name_first: Faker::Name.first_name,
          name_last: Faker::Name.last_name,
          document_type: 'ssn',
          document_value: '0000',
          birth_day: 12,
          birth_month: Faker::Date.backward(365 * 100).month,
          birth_year: Faker::Date.backward(365 * 100).year,
          address_street1: Faker::Address.street_address,
          address_city: Faker::Address.city,
          address_subdivision: Faker::Address.state_abbr,
          address_postal_code: Faker::Address.postcode,
          address_country_code: 'US'
        )
      end

      it { is_expected.not_to be_persisted }
      it { expect(person.class).to be BlockScore::Person }
    end

    describe '.create' do
      context 'vaild person' do
        subject(:person) do
          BlockScore::Person.create(
            name_first: Faker::Name.first_name,
            name_last: Faker::Name.last_name,
            document_type: 'ssn',
            document_value: '0000',
            birth_day: 12,
            birth_month: Faker::Date.backward(365 * 100).month,
            birth_year: Faker::Date.backward(365 * 100).year,
            address_street1: Faker::Address.street_address,
            address_city: Faker::Address.city,
            address_subdivision: Faker::Address.state_abbr,
            address_postal_code: Faker::Address.postcode,
            address_country_code: 'US'
          )
        end

        it { is_expected.to be_persisted }
        it { expect(person.class).to be BlockScore::Person }
      end

      context 'invaild person' do
        subject(:person) do
          BlockScore::Person.create(
            name_first: Faker::Name.first_name,
            name_last: Faker::Name.last_name,
            document_type: 'ssn',
            document_value: '0001',
            birth_day: 12,
            birth_month: Faker::Date.backward(365 * 100).month,
            birth_year: Faker::Date.backward(365 * 100).year,
            address_street1: Faker::Address.street_address,
            address_city: Faker::Address.city,
            address_subdivision: Faker::Address.state_abbr,
            address_postal_code: Faker::Address.postcode,
            address_country_code: 'US'
          )
        end

        it { is_expected.to be_persisted }
        it { expect(person.class).to be BlockScore::Person }
      end
    end

    pending '.find' do
      context 'valid person id' do
        let(:person_id)  { create(:person).id }
        subject(:person) { BlockScore::Person.find(person_id) }

        it { is_expected.to be_persisted }
        it { expect(person.name_first).not_to be_empty }
      end

      context 'invalid person id' do
        let(:person_id) { '6c89646eea50fcaa42ca1fe1667a470b' }

        it { expect { BlockScore::Person.find(person_id) }.to raise_error BlockScore::RecordNotFound }
      end
    end

    describe '.retrieve' do
      let(:person_id)  { create(:person).id }
      subject(:person) { BlockScore::Person.retrieve(person_id) }

      it { is_expected.to be_persisted }
      it { expect(person.name_first).not_to be_empty }
      it { expect(person.class).to be BlockScore::Person }
    end

    describe '.all' do
      let(:uniq_token_one) { '4c2c019a1e3c33442644d9f52c7a93f7' }
      let(:uniq_token_two) { 'b19a680671c6c006c6105aa450837668' }
      subject(:people) { BlockScore::Person.all }

      before do
        create(:person, name_first: 'John', name_last: uniq_token_one)
        create(:person, name_first: 'John', name_last: uniq_token_two)
      end

      it { is_expected.not_to be_empty }
      it { expect(people[0].name_last).to eq uniq_token_two }
      it { expect(people[1].name_last).to eq uniq_token_one }
    end

    describe '#valid?' do
      context 'valid person' do
        subject(:person) { create(:valid_person) }

        it { is_expected.to be_persisted }
        it { expect(person.valid?).to be true }
        it { expect(person.class).to be BlockScore::Person }
      end

      context 'invalid person' do
        subject(:person) { create(:invalid_person) }

        it { is_expected.to be_persisted }
        it { expect(person.valid?).to be false }
        it { expect(person.class).to be BlockScore::Person }
      end
    end

    describe '#invalid?' do
      context 'valid person' do
        subject(:person) { create(:valid_person) }

        it { is_expected.to be_persisted }
        it { expect(person.invalid?).to be false }
        it { expect(person.class).to be BlockScore::Person }
      end

      context 'invalid person' do
        subject(:person) { create(:invalid_person) }

        it { is_expected.to be_persisted }
        it { expect(person.invalid?).to be true }
        it { expect(person.class).to be BlockScore::Person }
      end
    end

    describe '#refresh' do
      subject(:person) { create(:person, name_first: 'John') }
      before do
        person.name_first = 'Mike'
        person.refresh
      end

      it { expect(person.name_first).to eq 'John' }
    end

    describe '#inspect' do
      subject(:person_inspection) { create(:person).inspect }
      it { expect(person_inspection.class).to be String }
    end

    describe '#update' do
      subject(:person) { create(:person) }
      it { expect { person.update(name_first: 'new_name') }.to raise_error NoMethodError }
    end

    describe '#delete' do
      subject(:person) { create(:person) }
      it { expect { person.delete }.to raise_error NoMethodError }
    end

    describe '#save' do
      subject(:person) { build(:person) }
      before { person.save }

      it { is_expected.to be_persisted }
      it { expect(person.class).to be BlockScore::Person }
    end
  end
end
