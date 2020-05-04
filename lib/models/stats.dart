class StateInfo {
 final double confirmed;
 final double active;
 final double deaths;
 final double deltaconfirmed;
 final double deltadeaths;
 final double deltarecovered;
 final double recovered;
 final String state;

 StateInfo({
   this.confirmed,
   this.active,
   this.deaths,
   this.recovered,
   this.deltaconfirmed,
   this.deltarecovered,
   this.deltadeaths,
   this.state,
 });
}
