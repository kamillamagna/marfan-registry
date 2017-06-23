import renderVitalForm from '../row_form_pieces/assembledVitalForm'

module.exports = function renderVitalsFields(topics, visit) {
  const parameterizedPlural = 'vitals'
  const fields = topics.map(t => renderVitalForm(t, visit))
  let returnStatement = `${fields.join('')}`
  return returnStatement
}
