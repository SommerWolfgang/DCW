table 6086411 "CEM Transaction Buffer CSV"
{
    Caption = 'Transaction Import Buffer CSV';

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(3; Value; Text[250])
        {
            Caption = 'Value';
        }
    }

    keys
    {
        key(Key1; "Line No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        StreamReader: Codeunit DotNet_StreamReader;
        IsTabDelimited: Boolean;
        TabChar: Char;
        Stream: InStream;
        IndexDoesNotExistErr: Label 'The field in line %1 with index %2 does not exist. The data could not be retrieved.';
        EscapeChar: Text[1];
        Separator: Text[1];


    procedure InitBuffer(CSVInStream: InStream; CSVFieldSeparator: Text[1]; CSVEncoding: Integer)
    var
        CurrentLineNo: Integer;
    begin
        DeleteAll;
        InitializeReaderFromStream(CSVInStream, CSVFieldSeparator, CSVEncoding);

        while not StreamReader.EndOfStream do begin
            CurrentLineNo += 1;
            ReadLine(CurrentLineNo);
        end;
    end;

    local procedure InitializeReaderFromStream(CSVInStream: InStream; CSVFieldSeparator: Text[1]; CSVEncoding: Integer)
    var
        Encoding: Codeunit DotNet_Encoding;
    begin
        Encoding.Encoding(CSVEncoding);

        StreamReader.StreamReader(CSVInStream, Encoding);
        Separator := CSVFieldSeparator;
        EscapeChar := '"';
        TabChar := 9;
    end;

    local procedure ReadLine(LineNo: Integer): Boolean
    var
        Escape: Boolean;
        FieldNo: Integer;
        Index: Integer;
        Length: Integer;
        Line: Text;
        Value: Text;
        Character: Text[1];
    begin
        if IsTabDelimited then
            Line := ConvertStr(StreamReader.ReadLine, Format(TabChar), ';')
        else
            Line := StreamReader.ReadLine;

        Length := StrLen(Line);

        for Index := 1 to Length do begin
            Character := CopyStr(Line, Index, 1);

            if IsEscape(Character) then begin
                SetEscape(Escape)
            end;

            if IsSeperator(Character) then begin
                if Escape then
                    Value += Character;
            end else
                Value += Character;

            if IsSeperator(Character) or IsEndOfLine(Index, Length) then
                if not Escape then begin
                    FieldNo += 1;
                    InsertEntry(LineNo, FieldNo, Value);
                    Clear(Value);
                end;

            if IsSeperator(Character) and IsEndOfLine(Index, Length) then begin
                FieldNo += 1;
                InsertEntry(LineNo, FieldNo, '');
            end;
        end;
    end;

    local procedure IsEscape(Character: Text[1]): Boolean
    begin
        exit(Character = EscapeChar);
    end;

    local procedure IsSeperator(Character: Text[1]): Boolean
    begin
        exit(Character = Separator);
    end;

    local procedure IsEndOfLine(Index: Integer; Length: Integer): Boolean
    begin
        exit(Index = Length);
    end;

    local procedure SetEscape(var Escape: Boolean)
    begin
        if Escape then
            Escape := false
        else
            Escape := true;
    end;

    local procedure InsertEntry(LineNo: Integer; FieldNo: Integer; FieldValue: Text[250])
    begin
        Init;
        "Line No." := LineNo;
        "Field No." := FieldNo;

        if StrLen(FieldValue) > 250 then
            FieldValue := CopyStr(FieldValue, 1, 250);

        Value := FieldValue;
        Insert;
    end;


    procedure GetValue(LineNo: Integer; FieldNo: Integer): Text[250]
    var
        TempCSVBuffer: Record "CEM Transaction Buffer CSV" temporary;
    begin
        TempCSVBuffer.Copy(Rec, true);
        if not TempCSVBuffer.Get(LineNo, FieldNo) then
            Error(IndexDoesNotExistErr, LineNo, FieldNo);

        exit(TempCSVBuffer.Value);
    end;


    procedure GetNumberOfLines(): Integer
    begin
        if FindLast then
            exit("Line No.");
    end;


    procedure LineHasDecimalValue(LineNo: Integer): Boolean
    var
        TempCSVBuffer: Record "CEM Transaction Buffer CSV" temporary;
        DecimalType: Decimal;
    begin
        TempCSVBuffer.Copy(Rec, true);
        TempCSVBuffer.Reset;
        TempCSVBuffer.SetRange("Line No.", "Line No.");

        if not TempCSVBuffer.FindSet then
            exit;

        repeat
            if Evaluate(DecimalType, TempCSVBuffer.GetValue(TempCSVBuffer."Line No.", TempCSVBuffer."Field No.")) then
                exit(true);
        until TempCSVBuffer.Next = 0;
    end;


    procedure LineHasSpecificValue(LineNo: Integer; Value: Text[250]): Boolean
    var
        TempCSVBuffer: Record "CEM Transaction Buffer CSV" temporary;
    begin
        TempCSVBuffer.Copy(Rec, true);
        TempCSVBuffer.Reset;
        TempCSVBuffer.SetRange("Line No.", LineNo);

        if not TempCSVBuffer.FindSet then
            exit;

        repeat
            if StrPos(TempCSVBuffer.Value, Value) > 0 then
                exit(true);
        until TempCSVBuffer.Next = 0;
    end;


    procedure SetIsTabDelimited(NewValue: Boolean)
    begin
        IsTabDelimited := NewValue;
    end;
}

