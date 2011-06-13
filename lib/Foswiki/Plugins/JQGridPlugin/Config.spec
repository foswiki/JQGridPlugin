# ---+ Extensions
# ---++ JQGridPlugin
# ---+++ Connectors
# **STRING 50**
# Default connector used when no other <code>connector</code> parameter is specified to the <code>%GRID</code> macro.
$Foswiki::cfg{JQGridPlugin}{DefaultConnector} = 'search';

# **STRING 50**
# Implementation handling the default <code>search</code> connector based on Foswiki's standard <code>%SEARCH</code>
# implementation. Note that for adequat performance using jqGrid you are recommended to use a better search algorithm than the default
# grep-based, or use the DBCachePlugin or SolrPlugin backends. See Foswiki::Store::SearchAlgorithms.
$Foswiki::cfg{JQGridPlugin}{Connector}{search} = 'Foswiki::Plugins::JQGridPlugin::SearchConnector';

# **STRING 50**
# Implementation handling the <code>dbcache</code> connector. This will require DBCachePlugin to be installed.
$Foswiki::cfg{JQGridPlugin}{Connector}{dbcache} = 'Foswiki::Plugins::JQGridPlugin::DBCacheConnector';

# **STRING 50**
# Implementation handling the <code>solr</code> connector. This will require SolrPlugin to be installed.
$Foswiki::cfg{JQGridPlugin}{Connector}{solr} = 'Foswiki::Plugins::JQGridPlugin::SolrConnector';

1;
