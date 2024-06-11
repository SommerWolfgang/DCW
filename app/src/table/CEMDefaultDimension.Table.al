table 6086368 "CEM Default Dimension"
{
    Caption = 'Default Dimension';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));

            trigger OnLookup()
            var
                TempObject: Record AllObj temporary;
            begin
                Clear(TempObject);
                EMDimMgt.SetupObjectNoList(TempObject);
                if PAGE.RunModal(358, TempObject) = ACTION::LookupOK then begin
                    "Table ID" := TempObject."Object ID";
                    Validate("Table ID");
                end;
            end;

            trigger OnValidate()
            var
                TempObject: Record AllObj temporary;
            begin
                CalcFields("Table Name");
                EMDimMgt.SetupObjectNoList(TempObject);
                TempObject."Object Type" := TempObject."Object Type"::Table;
                TempObject."Object ID" := "Table ID";
                if TempObject.IsEmpty then
                    FieldError("Table ID");
            end;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table ID" = CONST(6086307)) "CEM Expense Type";
        }
        field(3; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                if not DimMgt.CheckDim("Dimension Code") then
                    Error(DimMgt.GetDimErr);
            end;
        }
        field(4; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));

            trigger OnValidate()
            begin
                if not DimMgt.CheckDimValue("Dimension Code", "Dimension Value Code") then
                    Error(DimMgt.GetDimErr);
            end;
        }
        field(5; "Value Posting"; Option)
        {
            Caption = 'Value Posting';
            OptionCaption = ' ,Code Mandatory,Same Code,No Code';
            OptionMembers = " ","Code Mandatory","Same Code","No Code";
        }
        field(6; "Table Name"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Table),
                                                                           "Object ID" = FIELD("Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Multi Selection Action"; Option)
        {
            Caption = 'Multi Selection Action';
            OptionCaption = ' ,Change,Delete';
            OptionMembers = " ",Change,Delete;
        }
    }

    keys
    {
        key(Key1; "Table ID", "No.", "Dimension Code")
        {
            Clustered = true;
        }
        key(Key2; "Dimension Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        GLSetup.Get;
        if "Dimension Code" = GLSetup."Global Dimension 1 Code" then
            UpdateGlobalDimCode(1, "Table ID", "No.", '');
        if "Dimension Code" = GLSetup."Global Dimension 2 Code" then
            UpdateGlobalDimCode(2, "Table ID", "No.", '');
    end;

    trigger OnInsert()
    begin
        GLSetup.Get;
        if "Dimension Code" = GLSetup."Global Dimension 1 Code" then
            UpdateGlobalDimCode(1, "Table ID", "No.", "Dimension Value Code");
        if "Dimension Code" = GLSetup."Global Dimension 2 Code" then
            UpdateGlobalDimCode(2, "Table ID", "No.", "Dimension Value Code");
    end;

    trigger OnModify()
    begin
        GLSetup.Get;
        if "Dimension Code" = GLSetup."Global Dimension 1 Code" then
            UpdateGlobalDimCode(1, "Table ID", "No.", "Dimension Value Code");
        if "Dimension Code" = GLSetup."Global Dimension 2 Code" then
            UpdateGlobalDimCode(2, "Table ID", "No.", "Dimension Value Code");
    end;

    trigger OnRename()
    begin
        Error(Text000, TableCaption);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
        DimMgt: Codeunit DimensionManagement;
        Text000: Label 'You cannot rename a %1.';


    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        NewNo: Code[20];
        CurrTableID: Integer;
        NewTableID: Integer;
        SourceTableName: Text[100];
    begin
        if not Evaluate(NewTableID, GetFilter("Table ID")) then
            exit('');

        if NewTableID = 0 then
            if GetRangeMin("Table ID") = GetRangeMax("Table ID") then
                NewTableID := GetRangeMin("Table ID")
            else
                NewTableID := 0;

        if NewTableID <> CurrTableID then
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, NewTableID);
        CurrTableID := NewTableID;

        if GetFilter("No.") <> '' then
            if GetRangeMin("No.") = GetRangeMax("No.") then
                NewNo := GetRangeMin("No.")
            else
                NewNo := '';

        if NewTableID <> 0 then
            exit(StrSubstNo('%1 %2', SourceTableName, NewNo));

        exit('');
    end;

    local procedure UpdateGlobalDimCode(GlobalDimCodeNo: Integer; TableID: Integer; No: Code[20]; NewDimValue: Code[20])
    var
        ExpenseType: Record "CEM Expense Type";
    begin
        case "Table ID" of

            DATABASE::"CEM Expense Type":
                if ExpenseType.Get(No) then begin
                    case GlobalDimCodeNo of
                        1:
                            ExpenseType."Global Dimension 1 Code" := NewDimValue;
                        2:
                            ExpenseType."Global Dimension 2 Code" := NewDimValue;
                    end;
                    ExpenseType.Modify(true);
                end;
        end;
    end;
}

