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
    $('#evidence-form-holder').on("ajax:success", '#evidence-form', this.submitScore)
  },
  submitScore: function(event, data, status, xhr){
    $('#evidence-form').remove()
    $('#evidence-form-holder').append(data.submit_list)
  }

}

var domainPercentages = {
  init: function() {
    $('#domain-table').on("ajax:success", this.appendDashboard)
  },
  appendDashboard: function(event, data, status, xhr){
    debugger
    $('.dashboard').remove()
    $('.dashboard').append(data.domain_percentages)
  }
}

$(document).ready(function(){
  sideBar.toggle();
  evidenceScore.init();
  submitScore.init();
  domainPercentages.init();
})
