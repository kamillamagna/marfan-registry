import timeAgoField from './timeAgoField';
import fileAttachmentButton from './fileAttachmentButton';
import keywords from './keywords';
import measurementField from './measurementField';
import noteField from './noteField';
import findRelated from './findRelated';

module.exports = function assembledMeasurementForm(topic, unsortedTopics, rowID = topic.id) {
  const parameterizedPlural = 'tests';
  let returnStatement = `
  <tr class='row_form' id='row_${rowID}' style='display:none'><td colspan='3'>`
  if (topic.descriptors) {
    returnStatement += `<div class="form-group row">
      <label class="col-2 col-form-label">Descriptors</label>
      <div class="form-inline col-10">
        ${keywords(topic, parameterizedPlural)}
      </div>
    </div>`
  }
  returnStatement += `<div class="form-group row">
      <label class="col-2 col-form-label">Measurement</label>
      <div class="form-inline col-10">
        ${measurementField(topic, parameterizedPlural)}
      </div>
    </div>
    <div class="form-group row">
      <label class="col-2 col-form-label">Date</label>
      <div class="form-inline col-10">
        ${timeAgoField(topic, parameterizedPlural)}
      </div>
    </div>
    <div class="form-group row">
      <label class="col-2 col-form-label">Note</label>
      <div class="form-inline col-10">
        ${noteField(topic, parameterizedPlural)}        ${fileAttachmentButton(topic, parameterizedPlural)}
      </div>
    </div>
    ${findRelated(topic, unsortedTopics)}
  </td></tr>
  `;
  return returnStatement;
};
