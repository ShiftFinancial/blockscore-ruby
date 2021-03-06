module BlockScore
  class QuestionSet < Base
    extend Forwardable

    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::WriteOnce
    include BlockScore::Actions::All

    def_delegators 'self.class', :post

    def score(answers = nil)
      rescore(answers) if answers
      attributes.fetch(:score)
    end

    private

    def rescore(answers)
      capture_attributes(post(member_endpoint + 'score', answers: answers))
    end
  end
end
