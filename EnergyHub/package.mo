within ;
package EnergyHub "Modelica library for the model-based design and 
  optimization of multi-energy and energy hub systems"
  extends Modelica.Icons.Package;
annotation (
preferredView="info",
version="0.1",
versionDate="2025-10-10",
uses(Modelica(version="4.0.0"),
  Buildings(version="11.0.0")),
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
Modelcia Buildings Library</a> and aims to use the same general modeling
structure and practices as detailed in <a href=\"https://simulationresearch.lbl.gov/modelica/userGuide/bestPractice.html\">
Best Practices</a>.
</p>
<h4>Model Developers</h4>
<p>
 <ul>
 <li>Kathryn Hinkelman, University of Vermont
 <li>Malihe Davari, University of Vermont
 </ul>
</p>
<h4>References</h4>
<p>
[To be completed after peer review.]
</p>
</html>"));
end EnergyHub;
