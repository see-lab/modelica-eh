within EnergyHub.Examples.BaseClasses;
model KeyPerformanceIndicators
  "Set of post-processing calculations for economic and energy metrics"
  extends EnergyHub.Examples.Data.EconomicParameters;
  Modelica.Blocks.Continuous.Integrator EGriBuy(y_start=1E-10)
    "Energy purchased from the grid"
    annotation (Placement(transformation(extent={{220,16},{240,36}})));
  Modelica.Blocks.Continuous.Integrator EGriSel(k=-1, y_start=1E-10)
    "Energy sold back to the grid"
    annotation (Placement(transformation(extent={{220,-14},{240,6}})));
  Buildings.Utilities.Math.SmoothMax PGriBuy(deltaX=1e-6) "Purchased power"
    annotation (Placement(transformation(extent={{180,16},{200,36}})));
  Buildings.Utilities.Math.SmoothMin PGriSel(deltaX=1e-6) "Sold power"
    annotation (Placement(transformation(extent={{180,-14},{200,6}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Modelica.Blocks.Sources.RealExpression PGriNet "Net grid power (real)"
    annotation (Placement(transformation(extent={{140,22},{160,42}})));
  Modelica.Blocks.Continuous.Integrator ELoa(y_start=1E-10)
    "Total energy delivered to the load"
    annotation (Placement(transformation(extent={{220,86},{240,106}})));
  Modelica.Blocks.Math.Division ratEneImpLoa
    "Ratio of energy imported from the grid to the energy delivered to the load"
    annotation (Placement(transformation(extent={{260,100},{280,80}})));
  Modelica.Blocks.Math.Division ratEneExpPro
    "Ratio of energy exported to produced on-site"
    annotation (Placement(transformation(extent={{262,40},{282,20}})));
  Modelica.Blocks.Sources.RealExpression scr(y=1 - ratEneExpPro.y)
    "Self-consumption ratio"
    annotation (Placement(transformation(extent={{300,20},{320,40}})));
  Modelica.Blocks.Continuous.Integrator EGen(      y_start=1E-10)
    "Energy generated on site"
    annotation (Placement(transformation(extent={{220,50},{240,70}})));
  Modelica.Blocks.Sources.RealExpression PGen "Generated on-site power"
    annotation (Placement(transformation(extent={{180,50},{200,70}})));
  Modelica.Blocks.Sources.RealExpression ssr(y=1 - ratEneImpLoa.y)
    "Self-sufficiency ratio"
    annotation (Placement(transformation(extent={{300,80},{320,100}})));
  Modelica.Blocks.Sources.RealExpression PLoa(y=0)
    "Total load power  (positive)"
    annotation (Placement(transformation(extent={{180,86},{200,106}})));
  Modelica.Blocks.Math.Gain CBuy(k=gridBuyPrice) "Cost of buying electricity"
    annotation (Placement(transformation(extent={{260,-20},{280,0}})));
  Modelica.Blocks.Sources.RealExpression CCapIn(y=CCap)
    "Capital cost (internal block)"
    annotation (Placement(transformation(extent={{260,-80},{280,-60}})));
  Modelica.Blocks.Math.Gain CSel(k=-gridSellPrice)
    "Cost of sell electricity (negative)"
    annotation (Placement(transformation(extent={{260,-50},{280,-30}})));
  Modelica.Blocks.Math.Sum lcc(nin=3, k={PA,-PA,1})
                                                   "Life cycle cost"
    annotation (Placement(transformation(extent={{300,-40},{320,-20}})));
  Modelica.Blocks.Math.Gain preCos_MEur(k=1/1e6) "Million euros (Present cost)"
    annotation (Placement(transformation(extent={{334,-40},{354,-20}})));
  Modelica.Blocks.Sources.RealExpression lcoe(y=CCapIn.y/(EGen.y*PA/3.6e9))
    "Levalized cost of electricity (Eur/MWh)"
    annotation (Placement(transformation(extent={{300,-80},{320,-60}})));
equation
  connect(zer.y, PGriSel.u2)
    annotation (Line(points={{161,-10},{178,-10}}, color={0,0,127}));
  connect(zer.y, PGriBuy.u2) annotation (Line(points={{161,-10},{168,-10},{168,20},
          {178,20}}, color={0,0,127}));
  connect(PGriSel.y, EGriSel.u)
    annotation (Line(points={{201,-4},{218,-4}}, color={0,0,127}));
  connect(PGriBuy.y, EGriBuy.u)
    annotation (Line(points={{201,26},{218,26}}, color={0,0,127}));
  connect(PGriNet.y, PGriBuy.u1)
    annotation (Line(points={{161,32},{178,32}}, color={0,0,127}));
  connect(PGriNet.y, PGriSel.u1) annotation (Line(points={{161,32},{172,32},{172,
          2},{178,2}}, color={0,0,127}));
  connect(PLoa.y, ELoa.u)
    annotation (Line(points={{201,96},{218,96}}, color={0,0,127}));
  connect(PGen.y, EGen.u)
    annotation (Line(points={{201,60},{218,60}}, color={0,0,127}));
  connect(ELoa.y, ratEneImpLoa.u2)
    annotation (Line(points={{241,96},{258,96}}, color={0,0,127}));
  connect(EGen.y, ratEneExpPro.u2) annotation (Line(points={{241,60},{246,60},{
          246,36},{260,36}}, color={0,0,127}));
  connect(EGriSel.y, ratEneExpPro.u1) annotation (Line(points={{241,-4},{244,-4},
          {244,24},{260,24}}, color={0,0,127}));
  connect(EGriBuy.y, ratEneImpLoa.u1) annotation (Line(points={{241,26},{250,26},
          {250,84},{258,84}}, color={0,0,127}));
  connect(EGriBuy.y, CBuy.u) annotation (Line(points={{241,26},{250,26},{250,
          -10},{258,-10}}, color={0,0,127}));
  connect(CSel.u, EGriSel.y) annotation (Line(points={{258,-40},{244,-40},{244,
          -4},{241,-4}}, color={0,0,127}));
  connect(CBuy.y, lcc.u[1]) annotation (Line(points={{281,-10},{288,-10},{288,
          -30.6667},{298,-30.6667}}, color={0,0,127}));
  connect(CSel.y, lcc.u[2]) annotation (Line(points={{281,-40},{288,-40},{288,
          -30},{298,-30}}, color={0,0,127}));
  connect(CCapIn.y, lcc.u[3]) annotation (Line(points={{281,-70},{288,-70},{288,
          -29.3333},{298,-29.3333}}, color={0,0,127}));
  connect(lcc.y, preCos_MEur.u)
    annotation (Line(points={{321,-30},{332,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {320,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{320,100}}),
        graphics={Rectangle(
          extent={{120,120},{360,-100}},
          lineColor={95,95,95},
          fillColor={236,236,236},
          fillPattern=FillPattern.Solid), Text(
          extent={{172,122},{322,108}},
          textColor={95,95,95},
          fontSize=7,
          textStyle={TextStyle.Bold},
          textString="Economics & Energy Post-Processing")}),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end KeyPerformanceIndicators;
