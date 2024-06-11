table 6085757 "CDC Record Barcode"
{
    Caption = 'Record Barcode';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Source Record ID Tree ID"; Integer)
        {
            Caption = 'Record ID';
            TableRelation = "CDC Record ID Tree";
        }
        field(3; Barcode; Code[200])
        {
            Caption = 'Barcode';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Source Record ID Tree ID")
        {
        }
        key(Key3; Barcode)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        DCSetup: Record "CDC Document Capture Setup";
        RecBarcode: Record "CDC Record Barcode";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        RecBarcode.LockTable();
        if RecBarcode.FindLast() then
            "Entry No." := RecBarcode."Entry No." + 1
        else
            "Entry No." := 1;

        if Barcode = '' then begin
            DCSetup.Get();
            DCSetup.TestField("Barcode Nos.");
            NoSeriesMgt.InitSeries(DCSetup."Barcode Nos.", DCSetup."Barcode Nos.", WorkDate(), Barcode, DCSetup."Barcode Nos.");
        end;
    end;

    var
        Text001: Label 'Barcode %1 already exist for %2.';


    procedure GetBarcode(var RecRef: RecordRef): Code[50]
    begin
    end;


    procedure SaveBarcode(var RecRef: RecordRef; NewBarcode: Code[50]): Code[50]
    begin
    end;
}