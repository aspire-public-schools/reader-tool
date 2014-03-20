var sideBar = {
  toggle: function () {
    $('dl').on('click', 'dt', function(){
      var $this = $(this),
        $firstGroup = $this.nextUntil('dt');
      $firstGroup.toggle('fast', 'swing');
      $this.siblings('dd').not($firstGroup).hide()
    })
  }
}

var evidenceScore = {
    init: function () {
      $('.indicators').on("ajax:success", this.appendEvidence)
    },
    appendEvidence: function(event, data, status, xhr) {
      $('#evidence-form').remove()
      $('#evidence-form-holder').append(data.evidence_list)
    }
}

var submitScore = {
  init: function () {
    $('#evidence-form-holder').on("ajax:success", '#evidence-form', this.submitScoreAndDashboard)
  },
  submitScoreAndDashboard: function(event, data, status, xhr){
    $('#evidence-form').remove()
    $('#domain-table').remove()
    $('#evidence-form-holder').append(data.submit_list)
    $('.dashboard-holder').append(data.domain_percentages)
    $('#blast div').fadeIn('slow')
    $('#blast div').fadeOut(2500)
    $('#blast div').text(data.info)
    $('#blast').css({'display':'block'})
  }
}

var docLiveForm = {
  init: function() {
    $('.document-live-form-holder').on("ajax:success", this.updateDocLiveForm)
  },
  updateDocLiveForm: function(event, data, status, xhr){
    $('#submit-message').fadeIn('slow')
    $('#submit-message').fadeOut(2500)
    $('#submit-message').text(data.saved_message)
    $('.alert-success p').css({'display':'block'})
  }
}

$(document).ready(function(){
  sideBar.toggle();
  evidenceScore.init();
  submitScore.init();
  docLiveForm.init();
})
