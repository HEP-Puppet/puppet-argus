/*
 * puppet helper that will include the voms module related classes for individual VOs
 */
define argus::voms {
  include "::voms::${title}"
}
