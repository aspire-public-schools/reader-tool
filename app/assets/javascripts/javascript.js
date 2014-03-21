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
    debugger
    $('#evidence-form').remove()
    $('#domain-table').remove()
    $('#evidence-form-holder').append(data.submit_list)
    $('.dashboard-holder').append(data.domain_percentages)
    $('#blast div').fadeIn('slow')
    $('#blast div').fadeOut(2500)
    $('#blast div').text(data.info)
    $('#blast').css({'display':'block'})
    setCert.documentCert();
    setCert.liveCert();
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

var setCert = {
  documentCert: function() {
    var q1Value = parseFloat($('.quality #domain1-hidden').text())
    var q4Value = parseFloat($('.quality #domain4-hidden').text())
    if (q1Value >= 80 && q4Value >= 80) {
      $('#observation_read_document_quality').val(2)
    } else {
      $('#observation_read_document_quality').val(1)
    }

    var a1Value = parseFloat($('.alignment #domain5-hidden').text())
    var a4Value = parseFloat($('.alignment #domain8-hidden').text())

    if (a1Value >= 75 && a4Value >= 75) {
      $('#observation_read_document_alignment').val(2)
    } else {
      $('#observation_read_document_alignment').val(1)
    }
  },
  liveCert: function() {
    var q2Value = parseFloat($('.quality #2').text())
    var q3Value = parseFloat($('.quality #3').text())

    if (q2Value >= 80 && q3Value >= 80) {
      $('#observation_read_live_quality').val(2)
    } else {
      $('#observation_read_live_quality').val(1)
    }

    var a2Value = parseFloat($('.alignment #6').text())
    var a3Value = parseFloat($('.alignment #7').text())

    if (a2Value >= 75 && a3Value >= 75) {
      $('#observation_read_live_alignment').val(2)
    } else {
      $('#observation_read_live_alignment').val(1)
    }
  }
}

$(document).ready(function(){
  sideBar.toggle();
  evidenceScore.init();
  submitScore.init();
  docLiveForm.init();
  setCert.documentCert();
  setCert.liveCert();






})