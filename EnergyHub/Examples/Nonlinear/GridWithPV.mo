within EnergyHub.Examples.Nonlinear;
model GridWithPV "Nonlinear model with grid and PV"
  extends EnergyHub.Examples.Nonlinear.GridOnly(
    CCap=capExOnePV*nPV,
    PGen(y=pv.P));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv(
    pf=1,
    eta_DCAC=1,
    A=PV_surface*nPV,
    fAct=1,
    eta=PV_eff,
    til=0,
    azi=0,
    V_nominal=V_nominal)
    "Solar pannel with orientation"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(pv.weaBus, weaBus) annotation (Line(
      points={{-50,59},{-50,100},{0,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pv.terminal, loa.terminal) annotation (Line(points={{-60,50},{-70,50},
          {-70,70},{-20,70}}, color={0,120,120}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{320,120}})),
    experiment(
      StartTime=18399600,
      StopTime=18482400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Examples/Nonlinear/GridWithPV.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end GridWithPV;
