table 6085579 "CDC Template"
{
    // CC01 CC1.30 05.05.2022 ATVIE.PPIC new fields 50000, 50001

    Caption = 'Template';
    DataCaptionFields = "No.", Type;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; "Category Code"; Code[10])
        {
            Caption = 'Category Code';
            TableRelation = "CDC Document Category";
        }
        field(5; "Source Record ID Tree ID"; Integer)
        {
            Caption = 'Source Record ID';
            TableRelation = "CDC Record ID Tree";
        }
        field(6; Default; Boolean)
        {
            Caption = 'Default';
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Identification,Master';
            OptionMembers = " ",Identification,Master;
        }
        field(8; "Codeunit ID: After Capture"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: After Capture';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));
        }
        field(9; "Recognize Lines"; Option)
        {
            Caption = 'Recognize Lines';
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(11; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
        }
        field(12; "Codeunit ID: Line Validation"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Line Validation';
        }
        field(13; "Codeunit ID: Doc. Validation"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Doc. Validation';
        }
        field(14; "Codeunit ID: Register"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Register';
        }
        field(19; "Search Text"; Code[200])
        {
            Caption = 'Search Text';

            trigger OnValidate()
            begin
                TestField(Type, Type::" ");
            end;
        }
        field(22; "Codeunit ID: Show Match"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Show Match';
        }
        field(24; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
        }
        field(25; "Codeunit ID: Translations"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Translations';
        }
        field(27; "Codeunit ID: Register (Y/N)"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Register (Y/N)';
        }
        field(29; "Hide Registration Messages"; Boolean)
        {
            Caption = 'Hide Registration Messages';
        }
        field(30; "Show Document After Register"; Option)
        {
            Caption = 'Show Document After Register';
            OptionCaption = 'Ask,Always,Never';
            OptionMembers = Ask,Always,Never;
        }
        field(31; "Codeunit ID: After Step 1"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: After Step 1';
        }
        field(32; "Codeunit ID: After Step 2"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: After Step 2';
        }
        field(35; "First Table Line Has Captions"; Boolean)
        {
            Caption = 'First Table Line Has Captions';
            InitValue = true;
        }
        field(36; "Codeunit ID: Line Capture"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Line Capture';
        }
        field(39; "Auto Receive Order Variance"; Boolean)
        {
            Caption = 'Auto Receive Order Variance';
        }
        field(40; "Auto Ship Return Order Var."; Boolean)
        {
            Caption = 'Auto Ship Return Order Variance';
        }
        field(41; "Posting Date"; Option)
        {
            Caption = 'Posting Date';
            OptionCaption = 'Use Document Date (recognized on document),Use Today,Use Work Date';
            OptionMembers = "Use Document Date (recognized on document)","Use Today","Use Work Date";
        }
        field(42; "Date Format"; Option)
        {
            Caption = 'Date Format';
            OptionCaption = 'Day / Month / Year,Month / Day / Year,Year / Day / Month,Year / Month / Day,Day / Year / Month,Month / Year / Day';
            OptionMembers = "Day / Month / Year","Month / Day / Year","Year / Day / Month","Year / Month / Day","Day / Year / Month","Month / Year / Day";
        }
        field(43; "Master Template No."; Code[20])
        {
            Caption = 'Master Template No.';
        }
        field(44; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(45; "Source Record Table ID"; Integer)
        {
            Caption = 'Source Record Table ID';
        }
        field(46; "Source Record No."; Code[50])
        {
            Caption = 'Source Record No.';
        }
        field(47; "Source Record Name"; Text[100])
        {
            Caption = 'Source Record Name';
        }
        field(100; "Purch. Auto Match"; Boolean)
        {
            Caption = 'Auto Match';
        }
        field(101; "Purch. Match Invoice"; Option)
        {
            Caption = 'Match Invoice';
            OptionCaption = 'No,Receipt Only,Order Only,Receipt or Order';
            OptionMembers = No,"Receipt Only","Order Only","Receipt or Order";
        }
        field(102; "Purch. Validate VAT Calc."; Boolean)
        {
            Caption = 'Validate VAT Calculation';
        }
        field(103; "Validate Line Totals"; Boolean)
        {
            Caption = 'Validate Line Totals';
        }
        field(104; "Purch. Inv. Reg. Step 1"; Option)
        {
            Caption = 'Invoice Reg. Step 1';
            OptionCaption = ' ,Create Invoice,Match Order & Create Invoice,Match & Update Order,Create Journal Lines';
            OptionMembers = " ","Create Invoice","Match Order & Create Invoice","Match & Update Order","Create Journal Lines";
        }
        field(105; "Purch. Inv. Reg. Step 2"; Option)
        {
            Caption = 'Invoice Reg. Step 2';
            OptionCaption = ' ,Submit for Approval,Release,Post';
            OptionMembers = " ","Submit for Approval",Release,Post;
        }
        field(106; "Max. Variance Amt Allowed LCY"; Decimal)
        {
            Caption = 'Max. Variance Amount Allowed (LCY)';
        }
        field(107; "Purch. Match Order No."; Option)
        {
            Caption = 'Match Order No.';
            OptionCaption = 'No,Yes - always,Yes - if present';
            OptionMembers = No,"Yes - always","Yes - if present";
        }
        field(108; "Purch. Match Item No."; Option)
        {
            Caption = 'Match Item No.';
            OptionCaption = 'No,Yes - always,Yes - if present';
            OptionMembers = No,"Yes - always","Yes - if present";
        }
        field(109; "Purch. Match Quantity"; Option)
        {
            Caption = 'Match Quantity';
            OptionCaption = 'No,Yes - always,Yes - if present';
            OptionMembers = No,"Yes - always","Yes - if present";
        }
        field(110; "Purch. Match Unit Cost"; Option)
        {
            Caption = 'Match Unit Cost';
            OptionCaption = 'No,Yes - always,Yes - if present';
            OptionMembers = No,"Yes - always","Yes - if present";
        }
        field(112; "Purch. Cr.Memo Reg. Step 1"; Option)
        {
            Caption = 'Credit Memo Reg. Step 1';
            OptionCaption = ' ,Create Credit Memo,Match Return Order & Create Credit Memo,Match & Update Return Order,Create Journal Lines';
            OptionMembers = " ","Create Credit Memo","Match Return Order & Create Credit Memo","Match & Update Return Order","Create Journal Lines";
        }
        field(113; "Purch. Cr.Memo Reg. Step 2"; Option)
        {
            Caption = 'Credit Memo Reg. Step 2';
            OptionCaption = ' ,Submit for Approval,Release,Post';
            OptionMembers = " ","Submit for Approval",Release,Post;
        }
        field(114; "Line Total Header Formula"; Code[250])
        {
            Caption = 'Line Total Header Formula';
            Description = 'Obsolete(''Not used'';Pending;''9.0'')';
        }
        field(115; "Allow Register without Amounts"; Boolean)
        {
            Caption = 'Allow Register w/o Amounts';
        }
        field(116; "Amount Validation"; Option)
        {
            Caption = 'Amount Validation';
            OptionCaption = 'Not Required,Amount Excl. VAT and Amount Incl. VAT must match imported amounts,Only Amount Incl. VAT must match imported amounts,Only Amount Excl. VAT must match imported amounts';
            OptionMembers = "Not Required","Amount Excl. VAT and Amount Incl. VAT must match imported amounts","Only Amount Incl. VAT must match imported amounts","Only Amount Excl. VAT must match imported amounts";
        }
        field(117; "Variance Posting Account"; Code[20])
        {
            Caption = 'Variance Posting Account';
        }
        field(118; "Purch. Auto App. within Var."; Boolean)
        {
            Caption = 'Auto Approve within Variance';
        }
        field(119; "Approval Flow Code"; Code[10])
        {
            Caption = 'Approval Flow Code';
        }
        field(120; "Use Vendor/Customer Item Nos."; Boolean)
        {
            Caption = 'Vendor/Customer uses your Item Nos.';
        }
        field(122; "Allowed Variance %"; Decimal)
        {
            Caption = 'Max. Variance % Allowed';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
        field(123; "Copy Matched Header Dimensions"; Boolean)
        {
            Caption = 'Copy Matched Header Dimensions';
        }
        field(124; "Purch. Match Credit Memo"; Option)
        {
            Caption = 'Match Credit Memo';
            OptionCaption = 'No,Return Shipment Only,Return Order Only,Return Shipment or Return Order';
            OptionMembers = No,"Return Shipment Only","Return Order Only","Return Shipment or Return Order";
        }
        field(200; "Interaction Template Code"; Code[10])
        {
            Caption = 'Interaction Template Code';
        }
        field(300; "Sales Order Reg. Step 1"; Option)
        {
            Caption = 'Order Reg. Step 1';
            OptionCaption = ' ,,Create Order';
            OptionMembers = " ",,"Create Order";
        }
        field(301; "Sales Order Reg. Step 2"; Option)
        {
            Caption = 'Order Reg. Step 2';
            OptionCaption = ' ,Submit for Approval,Release';
            OptionMembers = " ","Submit for Approval",Release;
        }
        field(302; "Merge from same E-mail"; Boolean)
        {
            Caption = 'Merge from same Email';
        }
        field(303; "Sales Cr.Memo Reg. Step 1"; Option)
        {
            Caption = 'Credit Memo Reg. Step 1';
            OptionCaption = ' ,Create Credit Memo';
            OptionMembers = " ","Create Credit Memo";
        }
        field(304; "Sales Cr.Memo Reg. Step 2"; Option)
        {
            Caption = 'Credit Memo Reg. Step 2';
            OptionCaption = ' ,Submit for Approval,Release';
            OptionMembers = " ","Submit for Approval",Release;
        }
        field(305; "Unit Cost - Variance Amt (LCY)"; Decimal)
        {
            Caption = 'Unit Cost - Variance Amt (LCY)';
        }
        field(306; "Unit Cost - Variance %"; Decimal)
        {
            Caption = 'Unit Cost - Variance %';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
        field(400; "Data Type"; Option)
        {
            Caption = 'Data Type';
            OptionCaption = 'PDF,XML';
            OptionMembers = PDF,XML;
        }
        field(402; "XML Ident. Template No."; Code[20])
        {
            Caption = 'XML Identification Template';
        }
        field(403; "Invoice XML Header Tag"; Text[150])
        {
            Caption = 'Invoice XML Header Tag';
        }
        field(404; "Invoice XML Line Tag"; Text[150])
        {
            Caption = 'Invoice XML Line Tag';
        }
        field(411; "Cr.Memo XML Header Tag"; Text[150])
        {
            Caption = 'Cr.Memo XML Header Tag';
        }
        field(412; "Cr.Memo XML Line Tag"; Text[150])
        {
            Caption = 'Cr.Memo XML Line Tag';
        }
        field(420; "XML Stylesheet File"; BLOB)
        {
            Caption = 'XML Stylesheet File';
        }
        field(421; "XML Stylesheet File Extension"; Text[30])
        {
            Caption = 'XML Stylesheet File Extension';
        }
        field(422; "XML Stylesheet Main Filename"; Text[250])
        {
            Caption = 'XML Stylesheet Main Filename';
        }
        field(423; "XML Stylesheet Main Filename C"; Text[250])
        {
            Caption = 'XML Stylesheet Main Filename Cr.Memo';
        }
        field(424; "Split XML at XPath Invoice"; Text[250])
        {
            Caption = 'Split at XML Path';
        }
        field(425; "Split XML at XPath Cr. Memo"; Text[250])
        {
            Caption = 'Split at XML Path';
        }
        field(50000; "Use Vendor/Customer Pharma Nos"; Boolean)
        {
            Caption = 'Vendor/Customer uses your Pharma Nos.';
        }
        field(50001; "Use Vendo/Customer EAN Barcode"; Boolean)
        {
            Caption = 'Vendor/Customer uses your EAN Barcode';
        }
        field(60000; "ALR Line Validation Type"; Option)
        {
            Caption = 'Line Validation Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Default Template Codeunit,Advanced Line Recognition';
            OptionMembers = TemplateCodeunit,AdvancedLineRecognition;
        }
        field(60001; "Autom. PO search"; Boolean)
        {
            Caption = 'Automatic PO search';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Category Code", Type)
        {
        }
        key(Key3; "Search Text")
        {
        }
        key(Key4; "Category Code", "Source Record ID Tree ID")
        {
        }
        key(Key5; "Source Record Table ID", "Source Record No.", "Category Code")
        {
        }
    }

    procedure CreateNew(DocCatCode: Code[20]; NewRecIDTreeID: Integer; CopyAllFields: Boolean): Code[20]
    begin
    end;

    procedure MakeUniqueNames(var Template: Record "CDC Template"; var TempTemplate: Record "CDC Template")
    begin
    end;

    procedure Clone(FromCompany: Text[30]; var FromTemplate: Record "CDC Template"; ToDocCatCode: Code[10]; ToTemplNo: Code[20]; ToTemplateType: Option " ",Identification,Master; IncludeAllFields: Boolean; CreatedFromMasterTemplate: Boolean): Code[20]
    begin
    end;


    procedure AssistEdit(OldTemplate: Record "CDC Template"): Boolean
    begin
    end;

    procedure GetSourceName(): Text[1024]
    begin
    end;

    procedure GetSourceIDCaption() Caption: Text[250]
    begin
    end;

    procedure GetSourceNameCaption() Caption: Text[250]
    begin
    end;

    procedure ManuallyAddTemplField(DocumentNo: Code[20]): Boolean
    begin
    end;

    procedure ManuallyRemoveTemplField(): Boolean
    begin
    end;

    procedure FormulaOnLookup(var Text: Text[1024]): Boolean
    begin
        Text := '';
    end;

    procedure SetSourceID(KeyValues: Text[250])
    begin
    end;

    procedure GetSourceID(): Text[250]
    begin
    end;

    procedure ShowMatchingGroup(): Boolean
    begin
    end;

    procedure DrillDownSearchTexts()
    begin
    end;

    procedure SetStylesheetFile(var TempFile: Record "CDC Temp File" temporary)
    var
        ReadStream: InStream;
        WriteStream: OutStream;
    begin
        Clear("XML Stylesheet File");
        "XML Stylesheet File".CreateOutStream(WriteStream);
        TempFile.GetDataStream(ReadStream);
        CopyStream(WriteStream, ReadStream);
        Modify();
    end;


    procedure GetStylesheetFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    var
        ReadStream: InStream;
    begin
        CalcFields("XML Stylesheet File");
        if not "XML Stylesheet File".HasValue then
            exit(false);

        "XML Stylesheet File".CreateInStream(ReadStream);
        TempFile.CreateFromStream(StrSubstNo('%1.%2', "No.", "XML Stylesheet File Extension"), ReadStream);
        exit(true);
    end;


    procedure ImportStylesheet()
    begin
    end;

    procedure ExportStylesheet()
    begin
    end;

    procedure ResetSortOrderOnTemplateFields(TemplateNo: Code[20])
    var
        TemplateField: Record "CDC Template Field";
        SortOrder: Integer;
    begin
        TemplateField.SetCurrentKey("Template No.", Type, "Sort Order");
        TemplateField.SetRange("Template No.", TemplateNo);
        TemplateField.SetRange(Type, TemplateField.Type::Header);
        SortOrder := 10;
        if TemplateField.FindSet(true) then
            repeat
                TemplateField."Sort Order" := SortOrder;
                TemplateField.Modify();
                SortOrder += 10;
            until TemplateField.Next() = 0;

        TemplateField.SetRange(Type, TemplateField.Type::Line);
        SortOrder := 10;
        if TemplateField.FindSet(true) then
            repeat
                TemplateField."Sort Order" := SortOrder;
                TemplateField.Modify();
                SortOrder += 10;
            until TemplateField.Next() = 0;
    end;


    procedure IsCreateJournalEnbled(): Boolean
    begin
        exit(("Purch. Cr.Memo Reg. Step 1" = "Purch. Cr.Memo Reg. Step 1"::"Create Journal Lines") or ("Purch. Inv. Reg. Step 1" = "Purch. Inv. Reg. Step 1"::"Create Journal Lines"));
    end;

    local procedure ResetDefaultVendorTemplates()
    var
        Template: Record "CDC Template";
    begin
        Template.SetFilter("No.", '<>%1', "No.");
        Template.SetRange("Category Code", "Category Code");
        Template.SetRange("Source Record ID Tree ID", "Source Record ID Tree ID");
        Template.SetRange("Data Type", "Data Type");
        if "XML Ident. Template No." <> '' then
            Template.SetRange("XML Ident. Template No.", "XML Ident. Template No.");
        if Template.FindSet() then
            repeat
                Template.Validate(Default, false);
                Template.Modify();
            until Template.Next() = 0;
    end;
}