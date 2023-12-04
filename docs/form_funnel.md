# Form Funnel Analytics

## Description
This feature captures form events when a form step is submitted and later analyzes them to gather information.

## Events
An event is tracked when an instance of a model is created, updated, or deleted, including any changes made to the model's fields. Certain fields can be filtered out using the `config/events/filtered_attributes.yml` file.

## Form Funnel Query
The `FormsFunnelQuery` class builds a hash representation of the funnel for eligible and ineligible forms. This is achieved by iterating over the registered steps in `StepFlow` and counting the number of forms grouped by eligibility.
