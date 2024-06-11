table 6086348 "CEM Table Filter Field EM"
{
    Caption = 'Table Filter Field EM';

    fields
    {
        field(1; "Table Filter GUID"; Guid)
        {
            Caption = 'Table Filter GUID';
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(4; "Value (Text)"; Text[250])
        {
            Caption = 'Value (Text)';
        }
        field(5; "Value (Integer)"; Integer)
        {
            Caption = 'Value (Integer)';
        }
        field(6; "Value (Date)"; Date)
        {
            Caption = 'Value (Date)';
        }
        field(7; "Value (Decimal)"; Decimal)
        {
            Caption = 'Value (Decimal)';
        }
        field(8; "Value (Boolean)"; Boolean)
        {
            Caption = 'Value (Boolean)';
        }
        field(9; "Filter Type"; Option)
        {
            Caption = 'Filter Type';
            OptionCaption = 'Fixed Filter,Field Type';
            OptionMembers = "Fixed Filter","Field Type";
        }
        field(11; "Field Type Code"; Code[20])
        {
            Caption = 'Field Type Code';
            TableRelation = "CEM Field Type";
        }
    }

    keys
    {
        key(Key1; "Table Filter GUID", "Field No.")
        {
            Clustered = true;
        }
        key(Key2; "Table Filter GUID", "Filter Type", "Field Type Code")
        {
        }
        key(Key3; "Filter Type", "Field Type Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Table Filter GUID" = EmptyGUID then
            "Table Filter GUID" := CreateGuid();
    end;

    var
        EmptyGUID: Guid;
        Text001: Label 'Field type %1 not supported for Table filtering.';


    procedure SetValues(var Value: Text[250]; var FilterType: Option "Fixed Filter","Field Type")
    var
        "Field": Record "Field";
    begin
        "Value (Text)" := '';
        "Value (Integer)" := 0;
        "Value (Date)" := 0D;
        "Value (Decimal)" := 0;
        "Value (Boolean)" := false;
        "Field Type Code" := '';

        if FilterType = FilterType::"Fixed Filter" then begin
            Field.Get("Table No.", "Field No.");

            case Field.Type of
                Field.Type::Code:
                    Validate("Value (Text)", UpperCase(Value));
                Field.Type::Text:
                    Validate("Value (Text)", Value);
                Field.Type::Date:
                    if Evaluate("Value (Date)", Value) then
                        ;
                Field.Type::Decimal:
                    if Evaluate("Value (Decimal)", Value) then
                        ;
                Field.Type::Boolean:
                    if Evaluate("Value (Boolean)", Value) then
                        ;
                Field.Type::Integer:
                    if Evaluate("Value (Integer)", Value) then
                        ;
                Field.Type::Option:
                    begin
                        Validate("Value (Text)", OptionStringToIntString(Value));
                    end;
                else
                    Error(Text001, Format(Field.Type));
            end;
        end else
            Validate("Field Type Code", Value);

        "Filter Type" := FilterType;
        GetValues(Value, FilterType);
    end;


    procedure GetValues(var Value: Text[250]; var FilterType: Option "Fixed Filter","Field Type")
    var
        "Field": Record "Field";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        Value := '';
        FilterType := "Filter Type";

        if "Filter Type" = "Filter Type"::"Fixed Filter" then begin
            if not Field.Get("Table No.", "Field No.") then
                exit;

            case Field.Type of
                Field.Type::Text, Field.Type::Code:
                    Value := "Value (Text)";
                Field.Type::Date:
                    Value := Format(Format("Value (Date)"));
                Field.Type::Decimal:
                    Value := Format(Format("Value (Decimal)"));
                Field.Type::Boolean:
                    Value := Format(Format("Value (Boolean)"));
                Field.Type::Integer:
                    Value := Format(Format("Value (Integer)"));
                Field.Type::Option:
                    Value := IntStringToOptionString("Value (Text)");

                else
                    Error(Text001, Format(FieldRef.Type));
            end;
        end else
            Value := "Field Type Code";
    end;

    local procedure OptionToInt(TableNumber: Integer; FieldNumber: Integer; OptionAsText: Text[250]): Integer
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        i: Integer;
        CapVal: array[100] of Text[1024];
    begin
        RecRef.Open(TableNumber);
        FieldRef := RecRef.Field(FieldNumber);
        Split(FieldRef.OptionCaption, ',', CapVal);
        i := 1;

        repeat
            if UpperCase(CapVal[i]) = UpperCase(OptionAsText) then
                exit(i - 1);
            i := i + 1;
        until i = 100;

        i := 1;
        repeat
            if CopyStr(UpperCase(CapVal[i]), 1, StrLen(OptionAsText)) = UpperCase(OptionAsText) then
                exit(i - 1);
            i := i + 1;
        until i = 100;

        exit(-1);
    end;

    local procedure IntToOption(TableNumber: Integer; FieldNumber: Integer; IntOption: Integer): Text[250]
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        i: Integer;
        CapVal: array[100] of Text[1024];
    begin
        RecRef.Open(TableNumber);
        FieldRef := RecRef.Field(FieldNumber);
        Split(FieldRef.OptionCaption, ',', CapVal);

        exit(CapVal[IntOption + 1]);
    end;

    local procedure Split(Text: Text[1024]; Splitter: Text[1]; var TextArray: array[100] of Text[1024])
    var
        i: Integer;
        Index: Integer;
    begin
        i := StrPos(Text, Splitter);

        while (i <> 0) and (Index < 100) do begin
            Index := Index + 1;
            if i < MaxStrLen(TextArray[Index]) then
                TextArray[Index] := CopyStr(Text, 1, i - 1)
            else
                TextArray[Index] := CopyStr(Text, 1, MaxStrLen(TextArray[Index]));
            Text := CopyStr(Text, i + 1);
            i := StrPos(Text, Splitter);
        end;
        TextArray[Index + 1] := Text;
    end;


    procedure ShowTableFields(TableNo: Integer; FieldTypeCodeFilter: Text[1024]; var SourceGUID: Guid)
    begin
    end;

    procedure OptionStringToIntString(OptionsAsTextString: Text[250]) OptionsAsIntString: Text[250]
    begin
    end;

    local procedure IntStringToOptionString(OptionsAsIntString: Text[250]) OptionsAsTextString: Text[250]
    var
        i: Integer;
        IntValue: Integer;
        OptionsAsArray: array[100] of Text[1024];
    begin
        Split(OptionsAsIntString, '|', OptionsAsArray);

        for i := 1 to ArrayLen(OptionsAsArray) do begin
            if OptionsAsArray[i] <> '' then begin
                Evaluate(IntValue, OptionsAsArray[i]);
                if OptionsAsTextString <> '' then
                    OptionsAsTextString += '|';
                OptionsAsTextString += IntToOption("Table No.", "Field No.", IntValue);
            end;
        end;
    end;
}

