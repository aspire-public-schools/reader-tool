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
  }
}

var successAlert = {
  // init: function(){
  //   debugger
  //   $('#submit-evidence').on('submit', this.display)
  // },
  display: function(){
    e.preventDefault()
    $('#alert').css('display','block');
  }
}

$(document).ready(function(){
  sideBar.toggle();
  evidenceScore.init();
  submitScore.init();
  $('#submit-evidence').on('click', successAlert.display)
})
