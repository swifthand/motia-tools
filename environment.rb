require 'erb'
require 'csv'
require 'logger'

load 'registry.rb'
load 'encoding_priority_csv.rb'
load 'template_merge.rb'
load 'template_merge_single.rb'
load 'template_merge_multiple.rb'

MotiaTools.logger.info("-----------------------------------\n  Loaded motia-tools environment! \n-----------------------------------")
