within EnergyHub;
package Examples "Collection of models that illustrate model use and test models"
  extends Modelica.Icons.ExamplesPackage;
  annotation (
  preferredView="info",
  Documentation(info="<html>
<p>
This package contains examples of system models for energy hubs. 
We include both linear and nonlinear formulations to evaluate the effect of 
linearization on accuracy and numerical performance. 
</p>
<p>
It is important to note that the <u><b>linear models</b></u> 
induce <b>calculation error</b> with the current simplifications 
(e.g., constant COPs for heat pumps) for annual energy simulations 
and as such <b>should be used with caution</b>. It is up to the user to 
understand the use cases and limitations of various models. 
While this is a common simplification with linear programming, 
we include the models nonetheless for comparitive purposes and to 
allow others to adopt them for other use cases, where they may be more relevant. 
</p>
<p>
In contrast, the <u><b>nonlinear models</b></u> capture important physics dynamically 
and are suitable for annual energy calculations, 
design optimization, and other similar studies. 
</p>
</html>"));
end Examples;
