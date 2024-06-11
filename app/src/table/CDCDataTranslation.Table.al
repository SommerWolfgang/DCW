table 6085584 "CDC Data Translation"
{
    Caption = 'Data Translation';

    fields
    {
        field(1; "Template No."; Code[20])
        {
            Caption = 'Template No.';
            NotBlank = true;
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Header Field,Line Field,,,Formula';
            OptionMembers = "Header Field","Line Field",,,Formula;
        }
        field(3; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
            TableRelation = if (Type = const("Header Field")) "CDC Template Field".Code where("Template No." = field("Template No."),
                                                                                             Type = field(Type))
            else
            if (Type = const("Line Field")) "CDC Template Field".Code where("Template No." = field("Template No."),
                                                                                                                                                                 Type = field(Type));
        }
        field(5; "Translate From"; Code[150])
        {
            Caption = 'Translate From';
        }
        field(6; "Field Code / Formula"; Text[250])
        {
            Caption = 'Field Code / Formula';
            TableRelation = "CDC Template Field".Code where("Template No." = field("Template No."),
                                                             Type = const(Header),
                                                             "Data Type" = const(Number));
            ValidateTableRelation = false;
        }
        field(10; "Field Description"; Text[50])
        {
            CalcFormula = lookup("CDC Template Field"."Field Name" where("Template No." = field("Template No."),
                                                                          Type = field(Type),
                                                                          Code = field("Field Code")));
            Caption = 'Field Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Transl. to VAT Prod. Post.Grp."; Code[20])
        {
            Caption = 'Translate to VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(100; "Translate to Type"; Option)
        {
            Caption = 'Translate to Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item),,Amount Distribution Code';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",,"Amount Distribution Code";

            trigger OnValidate()
            begin
                if "Translate to Type" = "Translate to Type"::"Amount Distribution Code" then
                    TestField(Type, Type::"Header Field");
                Validate("Translate to No.", '');
            end;
        }
        field(101; "Translate to No."; Code[20])
        {
            Caption = 'Translate to No.';
        }
        field(102; "Translate to UOM Code"; Code[10])
        {
            Caption = 'Translate to UOM Code';
            TableRelation = if ("Translate to Type" = const(Item)) "Item Unit of Measure".Code where("Item No." = field("Translate to No."));
        }
        field(103; "Translate to (Text)"; Text[250])
        {
            Caption = 'Translate to (Text)';
        }
        field(104; "Translate to Variant Code"; Code[10])
        {
            Caption = 'Translate to Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Translate to No."));
        }
    }

    keys
    {
        key(Key1; "Template No.", Type, "Field Code", "Translate From")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DeleteDims();
    end;

    var
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        HasGotGLSetup: Boolean;
        GLSetupShortcutDimCode: array[8] of Code[20];


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    var
        i: Integer;
    begin
        GetGLSetup();
        for i := 1 to 8 do
            ShortcutDimCode[i] := GetDimValue(GLSetupShortcutDimCode[i]);
    end;

    local procedure GetGLSetup()
    begin
        if not HasGotGLSetup then begin
            GLSetup.Get();
            GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
            GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
            GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
            GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
            GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
            GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
            GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
            GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
            HasGotGLSetup := true;
        end;
    end;


    procedure GetDimValue(DimCode: Code[20]): Code[20]
    var
        DataTranslDim: Record "CDC Data Translation Dimension";
    begin
        if DataTranslDim.Get("Template No.", Type, "Field Code", "Translate From", DimCode) then
            exit(DataTranslDim."Dimension Value Code");
    end;


    procedure LookupShortcutDimCode(DimensionNo: Integer; var ValueCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(DimensionNo, ValueCode);
        UpdateDimCode(DimensionNo, ValueCode);
    end;


    procedure ValidateShortcutDimCode(DimensionNo: Integer; var ValueCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(DimensionNo, ValueCode);
        UpdateDimCode(DimensionNo, ValueCode);
    end;


    procedure UpdateDimCode(DimensionNo: Integer; ValueCode: Code[20])
    var
        DataTranslDim: Record "CDC Data Translation Dimension";
    begin
        GetGLSetup();

        if ValueCode = '' then begin
            if DataTranslDim.Get("Template No.", Type, "Field Code", "Translate From", GLSetupShortcutDimCode[DimensionNo]) then
                DataTranslDim.Delete(true);
        end else begin
            if DataTranslDim.Get("Template No.", Type, "Field Code", "Translate From", GLSetupShortcutDimCode[DimensionNo]) then begin
                DataTranslDim.Validate("Dimension Value Code", ValueCode);
                DataTranslDim.Modify(true);
            end else begin
                DataTranslDim."Template No." := "Template No.";
                DataTranslDim."Field Type" := Type;
                DataTranslDim."Field Code" := "Field Code";
                DataTranslDim."Translate From" := "Translate From";
                DataTranslDim."Dimension Code" := GLSetupShortcutDimCode[DimensionNo];
                DataTranslDim."Dimension Value Code" := ValueCode;
                DataTranslDim.Insert(true);
            end;
        end;
    end;


    procedure DeleteDims()
    var
        DataTranslDim: Record "CDC Data Translation Dimension";
    begin
        DataTranslDim.SetRange("Template No.", "Template No.");
        DataTranslDim.SetRange("Field Type", Type);
        DataTranslDim.SetRange("Field Code", "Field Code");
        DataTranslDim.SetRange("Translate From", "Translate From");
        DataTranslDim.DeleteAll(true);
    end;
}

