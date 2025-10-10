within EnergyHub.Examples.Nonlinear;
model PVandBESS "Nonlinear model with PV and battery (BESS)"
  extends GridWithPV(
    CCap=capExOnePV*nPV+capExBat*EBatMax);
  Buildings.Electrical.AC.ThreePhasesBalanced.Storage.Battery bat(
    etaCha=etaBatChr,
    etaDis=etaBatDis,
    SOC_start=SOC_start,
    EMax=EBatMax,
    V_nominal=V_nominal)
    "Electric battery"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Controls.BatteryControl conBat(
    socMax=socMax,
    socMin=socMin,
    PBatMax=PBatMax,
    PDel=1e-6)
    "Battery controller"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Math.Gain inv(k=-1)
    "Flip sign based on standard convention"
    annotation (Placement(transformation(extent={{0,20},{-20,40}})));
equation
  connect(bat.terminal, loa.terminal) annotation (Line(points={{-40,-10},{-76,
          -10},{-76,70},{-20,70}},color={0,120,120}));
  connect(conBat.PBat, bat.P) annotation (Line(points={{-39,10},{-30,10},{-30,0}},
                               color={0,0,127}));
  connect(bat.SOC, conBat.soc) annotation (Line(points={{-19,-4},{-14,-4},{-14,
          -20},{-68,-20},{-68,2},{-62,2}}, color={0,0,127}));
  connect(pv.P, conBat.PGen) annotation (Line(points={{-39,57},{-30,57},{-30,34},
          {-74,34},{-74,10},{-62,10}}, color={0,0,127}));
  connect(sumLoa.y, inv.u)
    annotation (Line(points={{9,70},{6,70},{6,30},{2,30}}, color={0,0,127}));
  connect(inv.y, conBat.PLoa) annotation (Line(points={{-21,30},{-68,30},{-68,18},
          {-62,18}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{320,120}})),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Examples/Nonlinear/PVandBESS.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVandBESS;
