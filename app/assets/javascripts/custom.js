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
      $('.evidence-form').remove()
      $('.evidence-form-holder').append(data.evidence_list)
    }
}



// var submitScore = {
//   init: function () {
//     $('#submit-evidence').on("ajax:success", this.submitScore)
//   },
//   submitScore: function(event, data, status, xhr){
//     $('.evidence-form-update').append(data.submit_list)
//   }

// }

$(document).ready(function(){
  sideBar.toggle();
  evidenceScore.init();
  // submitScore.init();

  $('#myTab a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  })

})
