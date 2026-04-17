within ;
package EnergyHub "Modelica library for the model-based design and 
  optimization of multi-energy and energy hub systems"
  extends Modelica.Icons.Package;
annotation (
preferredView="info",
version="0.1",
versionDate="2025-10-10",
uses(Modelica(version="4.0.0"),
  Buildings(version="11.1.0")),
    Icon(graphics={
        Rectangle(
          extent={{0,-10},{64,-70}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,70},{4,10}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{4,40},{92,40}},
          color={0,140,72},
          arrow={Arrow.None,Arrow.Filled}),
        Line(points={{0,-24},{-36,-24},{-36,10}}, color={28,108,200}),
        Line(
          points={{40,40}},
          color={0,140,72},
          arrow={Arrow.Filled,Arrow.None}),
        Line(points={{40,40},{40,-10}}, color={0,140,72}),
        Line(
          points={{-92,-56},{0,-56}},
          color={28,108,200},
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-92,60},{-60,60}},
          color={0,140,72},
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-92,22},{-60,22}},
          color={238,46,47},
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{64,-40},{96,-40}},
          color={28,108,200},
          arrow={Arrow.None,Arrow.Filled})}),
    Documentation(info="<html>
<p>
The Modelica <code>EnergyHub</code> (EH) package is a free modeling
repository for designing and optimizing EH configurations.
</p>
<p>
Many models are based on models from the
<a href=\"modelica://Buildings\">
Modelica Buildings Library</a> and aims to use the same general modeling
structure and practices as detailed in <a href=\"https://simulationresearch.lbl.gov/modelica/userGuide/bestPractice.html\">
Best Practices</a>.
</p>
<h4>Tool Compatibility</h4>
<p>
These models have have been tested with Dymola 2025x and OpenModelica 1.25.0.
</p>
<h4>Model Developers</h4>
<ul>
 <li>Kathryn Hinkelman, SEE Lab, University of Vermont (kathryn.hinkelman@uvm.edu)</li>
 <li>Malihe Davari, SEE Lab, University of Vermont</li>
</ul>
<h4>Collaborators</h4>
<ul>
 <li>Jaume Fitó de la Cruz, LOICE Laboratory, Université Savoie Mont Blanc</li>
 <li>Julien Ramousse, LOICE Laboratory, Université Savoie Mont Blanc</li>
</ul>
<h4>Citation</h4>
<p>

M. Davari, K. Hinkelman, J. Fitó, and J. Ramousse, “Open-Source Modelica Models for the Optimal Design of Urban and Community Scale Multi-Energy Systems,” in The Twelfth National Conference of IBPSA-USA (SimBuild 2026), Minneapolis, MN, May 2026.
  
</p>
</html>"));
end EnergyHub;
