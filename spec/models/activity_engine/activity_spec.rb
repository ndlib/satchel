require 'spec_helper'

module ActivityEngine
  describe Activity do
    subject { ActivityEngine::Activity.new }
    let(:object) { PersistenceLayer.new }

    describe '#subject=' do
      describe 'with persisted object' do
        it 'should marshal the subject' do
          subject.subject = object
          expect(subject.subject).to eq(object)
        end

        it 'should capture the subject id' do
          subject.subject = object
          expect(subject.subject_id).to eq(object.to_param)
        end

        it 'should capture the subject type' do
          subject.subject = object
          expect(subject.subject_type).to eq(object.class.to_s)
        end
      end

      describe 'with a non persisted object' do
        it 'raise exception if the object is not persisted' do
          def object.persisted?; false; end
          expect {
            subject.subject = object
          }.to raise_error(ActivityEngine::UnpersistedSubjectError)
        end

        it 'raise exception if the object does not respond to persisted' do
          expect {
            subject.subject = 2
          }.to raise_error(NoMethodError)
        end
      end
    end
  end
end
