unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.UIConsts, System.Classes,
  System.Variants, System.Math, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  Charts.Math, Charts.Controls, Chart.Candles, Chart.Measures;

type

  TForm1 = class(TForm)
    Layout1: TLayout;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Layout1Paint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    Chart: TCandleChart;
    procedure CreateData;
    procedure OnCandleClick(Sender: TObject; const Candle: TCandle);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

function GenerateCandles: TCandles;

  function RandomValue(FromValue,Range1,Range2: Extended): Extended;
  begin
    Result:=EnsureValue(Random,0,1,FromValue+Range1,FromValue+Range2);
  end;

var
  C: TCandle;
  D: Integer;
  Area: TRectF;
begin

  Randomize;

  Area:=RectF(0,0.003,1000*100,0); // times: 0-100 sec. volume: 0-0.003

  Result:=nil;

  D:=1000; // duration: 1 sec

  // start candle

  C.Close:=Area.Top/2;
  C.Time:=Round(Area.Left)-D;

  while C.Time<Area.Right do
  begin

    C.Open:=C.Close;
    C.Close:=RandomValue(C.Open,-0.0004,0.0003);
    C.Max:=RandomValue(Max(C.Open,C.Close),0,0.0002);
    C.Min:=RandomValue(Min(C.Open,C.Close),0,-0.0002);
    C.Time:=C.Time+D;
    C.Duration:=D;

    Result:=Result+[C];

  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  Chart:=TCandleChart.Create(Self);
  Chart.Align:=TAlignLayout.Client;
  Chart.Parent:=Layout1;
  Chart.OnCandleClick:=OnCandleClick;

  CreateData;

end;

procedure TForm1.Layout1Paint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  Canvas.DrawDashRect(ARect,0,0,AllCorners,1,claBlueviolet);
end;

procedure TForm1.CreateData;
var
  Candles: TCandles;
  Measures: TMeasures;
  Measure: TMeasure;
  Elapses: TElapses;
  Elapse: TElapse;
begin

  Candles:=GenerateCandles;

  Measure.Value:=0;
  Measure.Text:='0.0';
  Measures:=[Measure];

  Measure.Value:=0.001;
  Measure.Text:='0.001';
  Measures:=Measures+[Measure];

  Elapse.Value:=Candles[4].Time;
  Elapse.Text:='24 ������';
  Elapses:=[Elapse];

  Elapse.Value:=Candles[20].Time;
  Elapse.Text:='25 ������';
  Elapses:=Elapses+[Elapse];

  Chart.SetData(Candles);
  Chart.SetValueMeasure(Measures);
  Chart.SetElapsesMeasure(Elapses);

  Chart.Duration:=60000;

end;

function AmountToStr(Amount: Extended): string;
begin
  Result:=FormatFloat('0.00###',Amount);
end;

procedure TForm1.OnCandleClick(Sender: TObject; const Candle: TCandle);
begin
  ShowMessage(
    'Open: '+AmountToStr(Candle.Open)+#10+
    'Close: '+AmountToStr(Candle.Close)+#10+
    'Max: '+AmountToStr(Candle.Max)+#10+
    'Min: '+AmountToStr(Candle.Min));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  CreateData;
  Chart.Repaint;
end;

end.