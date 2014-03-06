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
      $(document).on("ajax:success", this.appendEvidence)
    },
    appendEvidence: function(event, data, status, xhr) {
        $('#evidence-form').remove()
        $('.evidence-form').append(data.evidence_list)
    }
  }

$(document).ready(function(){
  sideBar.toggle();
  evidenceScore.init();
})
