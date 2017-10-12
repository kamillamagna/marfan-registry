import React from 'react';
import PropTypes from 'prop-types';
import DurationField from './DurationField';
import FileAttachmentButton from './FileAttachmentButton';
import FindRelated from './FindRelated';
import HiddenFields from './HiddenFields';
import Keywords from './Keywords';
import NoteField from './NoteField';
import TimeAgoField from './TimeAgoField';

export default class AssembledHospitalizationForm extends React.Component {
  render() {
    const parameterizedPlural = 'hospitalizations'
    let descriptors
    if (this.props.topic.descriptors) {
      descriptors = (
        <div className="form-group row">
          <label className="col-2 col-form-label">
            Descriptors
          </label>
          <div className="form-inline col-10">
            <Keywords
              topic={this.props.topic}
              parameterizedPlural={parameterizedPlural}
              rowID={this.props.rowID}
            />
          </div>
        </div>
      );
    }
    return (
      <tr className="row_form" id={'row_' + this.props.rowID}>
        <td colSpan="3">
          <HiddenFields
            visit={this.props.visit}
            topic={this.props.topic}
            parameterizedPlural={parameterizedPlural}
            rowID={this.props.rowID}
          />
          <div className="form-group row">
            <label className="col-2 col-form-label">
              Admission Date
            </label>
            <div className="form-inline col-10">
              <TimeAgoField
                topic={this.props.topic}
                parameterizedPlural={parameterizedPlural}
                rowID={this.props.rowID}
              />
            </div>
            <div className="form-group row">
              <label className="col-2 col-form-label">
                Length of Stay
              </label>
              <div className="form-inline col-10">
                <DurationField
                  topic={this.props.topic}
                  parameterizedPlural={parameterizedPlural}
                  rowID={this.props.rowID}
                />
              </div>
            </div>
            <div className="form-group row">
              <label className="col-2 col-form-label">
                Descriptors
              </label>
              <div className="form-inline col-10">
                <NoteField
                  topic={this.props.topic}
                  parameterizedPlural={parameterizedPlural}
                  rowID={this.props.rowID}
                />
                <FileAttachmentButton
                  topic={this.props.topic}
                  parameterizedPlural={parameterizedPlural}
                  rowID={this.props.rowID}
                />
              </div>
            </div>
            <FindRelated
              topic={this.props.topic}
              unsortedTopics={this.props.unsortedTopics}
            />
          </div>
        </td>
      </tr>
    );
  }
}

AssembledHospitalizationForm.propTypes = {
  topic: PropTypes.object.isRequired,
  unsortedTopics: PropTypes.array.isRequired,
  visit: PropTypes.object.isRequired,
  rowID: PropTypes.number.isRequired
};