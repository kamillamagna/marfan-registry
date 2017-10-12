import PropTypes from 'prop-types';
import React from 'react';
import $ from 'jquery';
import SelectConstructor from './SelectConstructor';
require('../addKeyboard');
require('jquery-ujs');
require('jquery-ui/ui/core.js');
require('jquery-ui/ui/position');

export default class MeasurementField extends React.Component {
  constructor() {
    super();
    this.keyboardize = this.keyboardize.bind(this)
  }

  componentDidMount() {
    this.$el = $(this.el);
    this.$el.addKeyboard();
  }

  componentWillUnmount() {
    this.$el.addKeyboard('destroy');
  }

  keyboardize(e) {
    e.preventDefault();
    this.$el = $(this.el);
    const kb = this.$el.getkeyboard();
    // close the keyboard if the keyboard is visible and the button is clicked a second time
    if (kb.isOpen) {
      kb.close();
    } else {
      kb.reveal();
    }
  }

  render() {
    const options = this.props.topic.units_of_measurement
    return (
      <div className="form-inline">
        <input
          type="number"
          name={'visit[' + this.props.parameterizedPlural + '_attributes][' + this.props.rowID + '][test_amount]'}
          id={'visit_' + this.props.parameterizedPlural + '_attributes_' + this.props.rowID + '_test_amount'}
          className='form-control calculator'
          min={this.props.topic.min_value}
          max={this.props.topic.max_value}
          step={this.props.topic.step}
          value=""
          ref={el => this.el = el}
        />
        <button
          className="btn btn-secondary calculator"
          type="button"
          id={this.props.parameterizedPlural + '_' + this.props.rowID + '_test_calc_button'}
          onClick={this.keyboardize}
        >
          <i className="fa fa-calculator" />
        </button>
        <SelectConstructor
          arr={options}
          title={this.props.title}
          other={false}
          attribute="test_unit_of_meas"
          parameterizedPlural={this.props.parameterizedPlural}
          rowID={this.props.rowID}
          multiSelect={this.props.multiSelect}
        />
      </div>
    );
  }
}

MeasurementField.defaultProps = {
  title: 'units',
  multiSelect: false,
};

MeasurementField.propTypes = {
  topic: PropTypes.object.isRequired,
  parameterizedPlural: PropTypes.string.isRequired,
  multiSelect: PropTypes.bool.isRequired,
  title: PropTypes.string.isRequired,
  rowID: PropTypes.number.isRequired,
};