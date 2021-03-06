#
# This file is part of ruby-ffi.
#
# This code is free software: you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License version 3 only, as
# published by the Free Software Foundation.
#
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
# version 3 for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# version 3 along with this work.  If not, see <http://www.gnu.org/licenses/>.
#

require File.expand_path(File.join(File.dirname(__FILE__), "spec_helper"))

module TestEnum0
  extend FFI::Library
end

module TestEnum1
  extend FFI::Library
  ffi_lib TestLibrary::PATH

  enum [:c1, :c2, :c3, :c4]
  enum [:c5, 42, :c6, :c7, :c8]
  enum [:c9, 42, :c10, :c11, 4242, :c12]
  enum [:c13, 42, :c14, 4242, :c15, 424242, :c16, 42424242]
  
  attach_function :test_untagged_enum, [:int], :int
end

module TestEnum3
  extend FFI::Library
  ffi_lib TestLibrary::PATH

  enum :enum_type1, [:c1, :c2, :c3, :c4]
  enum :enum_type2, [:c5, 42, :c6, :c7, :c8]
  enum :enum_type3, [:c9, 42, :c10, :c11, 4242, :c12]
  enum :enum_type4, [:c13, 42, :c14, 4242, :c15, 424242, :c16, 42424242]

  attach_function :test_tagged_typedef_enum1, [:enum_type1], :enum_type1
  attach_function :test_tagged_typedef_enum2, [:enum_type2], :enum_type2
  attach_function :test_tagged_typedef_enum3, [:enum_type3], :enum_type3
  attach_function :test_tagged_typedef_enum4, [:enum_type4], :enum_type4
end

describe "A library with no enum defined" do
  it "returns nil when asked for an enum" do
    TestEnum0.enum_type(:foo).should eq nil
  end
end

describe "An untagged enum" do
  it "constants can be used as function parameters and return value" do
    TestEnum1.test_untagged_enum(:c1).should eq 0
    TestEnum1.test_untagged_enum(:c2).should eq 1
    TestEnum1.test_untagged_enum(:c3).should eq 2
    TestEnum1.test_untagged_enum(:c4).should eq 3
    TestEnum1.test_untagged_enum(:c5).should eq 42
    TestEnum1.test_untagged_enum(:c6).should eq 43
    TestEnum1.test_untagged_enum(:c7).should eq 44
    TestEnum1.test_untagged_enum(:c8).should eq 45
    TestEnum1.test_untagged_enum(:c9).should eq 42
    TestEnum1.test_untagged_enum(:c10).should eq 43
    TestEnum1.test_untagged_enum(:c11).should eq 4242
    TestEnum1.test_untagged_enum(:c12).should eq 4243
    TestEnum1.test_untagged_enum(:c13).should eq 42
    TestEnum1.test_untagged_enum(:c14).should eq 4242
    TestEnum1.test_untagged_enum(:c15).should eq 424242
    TestEnum1.test_untagged_enum(:c16).should eq 42424242
  end
end

describe "A tagged typedef enum" do
  it "is accessible through its tag" do
    TestEnum3.enum_type(:enum_type1).should_not eq nil
    TestEnum3.enum_type(:enum_type2).should_not eq nil
    TestEnum3.enum_type(:enum_type3).should_not eq nil
    TestEnum3.enum_type(:enum_type4).should_not eq nil
  end
  it "contains enum constants" do
    TestEnum3.enum_type(:enum_type1).symbols.length.should eq 4
    TestEnum3.enum_type(:enum_type2).symbols.length.should eq 4
    TestEnum3.enum_type(:enum_type3).symbols.length.should eq 4
    TestEnum3.enum_type(:enum_type4).symbols.length.should eq 4
  end
  it "constants can be used as function parameters and return value" do
    TestEnum3.test_tagged_typedef_enum1(:c1).should eq :c1
    TestEnum3.test_tagged_typedef_enum1(:c2).should eq :c2
    TestEnum3.test_tagged_typedef_enum1(:c3).should eq :c3
    TestEnum3.test_tagged_typedef_enum1(:c4).should eq :c4
    TestEnum3.test_tagged_typedef_enum2(:c5).should eq :c5
    TestEnum3.test_tagged_typedef_enum2(:c6).should eq :c6
    TestEnum3.test_tagged_typedef_enum2(:c7).should eq :c7
    TestEnum3.test_tagged_typedef_enum2(:c8).should eq :c8
    TestEnum3.test_tagged_typedef_enum3(:c9).should eq :c9
    TestEnum3.test_tagged_typedef_enum3(:c10).should eq :c10
    TestEnum3.test_tagged_typedef_enum3(:c11).should eq :c11
    TestEnum3.test_tagged_typedef_enum3(:c12).should eq :c12
    TestEnum3.test_tagged_typedef_enum4(:c13).should eq :c13
    TestEnum3.test_tagged_typedef_enum4(:c14).should eq :c14
    TestEnum3.test_tagged_typedef_enum4(:c15).should eq :c15
    TestEnum3.test_tagged_typedef_enum4(:c16).should eq :c16
  end

  it "integers can be used instead of constants" do
    TestEnum3.test_tagged_typedef_enum1(0).should eq :c1
    TestEnum3.test_tagged_typedef_enum1(1).should eq :c2
    TestEnum3.test_tagged_typedef_enum1(2).should eq :c3
    TestEnum3.test_tagged_typedef_enum1(3).should eq :c4
    TestEnum3.test_tagged_typedef_enum2(42).should eq :c5
    TestEnum3.test_tagged_typedef_enum2(43).should eq :c6
    TestEnum3.test_tagged_typedef_enum2(44).should eq :c7
    TestEnum3.test_tagged_typedef_enum2(45).should eq :c8
    TestEnum3.test_tagged_typedef_enum3(42).should eq :c9
    TestEnum3.test_tagged_typedef_enum3(43).should eq :c10
    TestEnum3.test_tagged_typedef_enum3(4242).should eq :c11
    TestEnum3.test_tagged_typedef_enum3(4243).should eq :c12
    TestEnum3.test_tagged_typedef_enum4(42).should eq :c13
    TestEnum3.test_tagged_typedef_enum4(4242).should eq :c14
    TestEnum3.test_tagged_typedef_enum4(424242).should eq :c15
    TestEnum3.test_tagged_typedef_enum4(42424242).should eq :c16
  end
end

describe "All enums" do
  it "have autonumbered constants when defined with names only" do
    TestEnum1.enum_value(:c1).should eq 0
    TestEnum1.enum_value(:c2).should eq 1
    TestEnum1.enum_value(:c3).should eq 2
    TestEnum1.enum_value(:c4).should eq 3

    TestEnum3.enum_value(:c1).should eq 0
    TestEnum3.enum_value(:c2).should eq 1
    TestEnum3.enum_value(:c3).should eq 2
    TestEnum3.enum_value(:c4).should eq 3
  end
  it "can have an explicit first constant and autonumbered subsequent constants" do
    TestEnum1.enum_value(:c5).should eq 42
    TestEnum1.enum_value(:c6).should eq 43
    TestEnum1.enum_value(:c7).should eq 44
    TestEnum1.enum_value(:c8).should eq 45

    TestEnum3.enum_value(:c5).should eq 42
    TestEnum3.enum_value(:c6).should eq 43
    TestEnum3.enum_value(:c7).should eq 44
    TestEnum3.enum_value(:c8).should eq 45
  end
  it "can have a mix of explicit and autonumbered constants" do
    TestEnum1.enum_value(:c9).should  eq 42
    TestEnum1.enum_value(:c10).should eq 43
    TestEnum1.enum_value(:c11).should eq 4242
    TestEnum1.enum_value(:c12).should eq 4243

    TestEnum3.enum_value(:c9).should  eq 42
    TestEnum3.enum_value(:c10).should eq 43
    TestEnum3.enum_value(:c11).should eq 4242
    TestEnum3.enum_value(:c12).should eq 4243
  end
  it "can have all its constants explicitely valued" do
    TestEnum1.enum_value(:c13).should eq 42
    TestEnum1.enum_value(:c14).should eq 4242
    TestEnum1.enum_value(:c15).should eq 424242
    TestEnum1.enum_value(:c16).should eq 42424242
    
    TestEnum3.enum_value(:c13).should eq 42
    TestEnum3.enum_value(:c14).should eq 4242
    TestEnum3.enum_value(:c15).should eq 424242
    TestEnum3.enum_value(:c16).should eq 42424242
  end
  it "return the constant corresponding to a specific value" do
    enum = TestEnum3.enum_type(:enum_type1)
    enum[0].should eq :c1
    enum[1].should eq :c2
    enum[2].should eq :c3
    enum[3].should eq :c4

    enum = TestEnum3.enum_type(:enum_type2)
    enum[42].should eq :c5
    enum[43].should eq :c6
    enum[44].should eq :c7
    enum[45].should eq :c8

    enum = TestEnum3.enum_type(:enum_type3)
    enum[42].should eq :c9
    enum[43].should eq :c10
    enum[4242].should eq :c11
    enum[4243].should eq :c12

    enum = TestEnum3.enum_type(:enum_type4)
    enum[42].should eq :c13
    enum[4242].should eq :c14
    enum[424242].should eq :c15
    enum[42424242].should eq :c16
  end
  it "return nil for values that don't have a symbol" do
    enum = TestEnum3.enum_type(:enum_type1)
    enum[-1].should eq nil
    enum[4].should eq nil

    enum = TestEnum3.enum_type(:enum_type2)
    enum[0].should eq nil
    enum[41].should eq nil
    enum[46].should eq nil

    enum = TestEnum3.enum_type(:enum_type3)
    enum[0].should eq nil
    enum[41].should eq nil
    enum[44].should eq nil
    enum[4241].should eq nil
    enum[4244].should eq nil

    enum = TestEnum3.enum_type(:enum_type4)
    enum[0].should eq nil
    enum[41].should eq nil
    enum[43].should eq nil
    enum[4241].should eq nil
    enum[4243].should eq nil
    enum[424241].should eq nil
    enum[424243].should eq nil
    enum[42424241].should eq nil
    enum[42424243].should eq nil
  end

  it "duplicate enum keys rejected" do
    lambda { enum [ :a, 0xfee1dead, :b, 0xdeadbeef, :a, 0 ] }.should raise_error
  end
end
